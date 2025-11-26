// app.js — volledig gefixt en verbeterd voor:
// - correcte access token scope
// - prev/next via Web API
// - realtime progress updates (ms-based)
// - stabiele seeking (no overshoot)
// - UI sync via player_state_changed

document.addEventListener("DOMContentLoaded", function() {
  console.log("--- START OAuth V4 / Spotify Web Playback SDK ---");

  let spotifyAccessToken = null;
  let spotifyDeviceId = null;
  let player = null;
  let queue = [];
  let currentIndex = 0;

  // UI elementen
  const loginBtn = document.getElementById("login-button");

loginBtn.addEventListener("click", () => {
    window.location.href = "login.php";
});

  const logoutBtn = document.getElementById("logout-button");

logoutBtn.addEventListener("click", () => {
    fetch("logout.php")
        .then(() => {
            showNotification("Succesvol uitgelogd.");
            setTimeout(() => {
                window.location.reload(); // <-- pagina opnieuw laden
            }, 600);
            loginBtn.style.display = "inline-block";
            logoutBtn.style.display = "none";
        });
});

  const userProfileEl = document.getElementById('user-profile');
  const top10LijstEl = document.getElementById('top-10-lijst');

  const titleEl = document.getElementById('player-title');
  const artistEl = document.getElementById('player-artist');
  const coverEl = document.getElementById('player-cover');
  const playPauseBtn = document.getElementById('play-pause-btn');
  const prevBtn = document.getElementById('prev-btn');
  const nextBtn = document.getElementById('next-btn');
  const progressBar = document.getElementById('progress-bar');

  // SVG icons tuned to Figma style: outlined prev/next (stroke-only) and filled triangle for play/pause
  const ICON_PREV = '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">'
    + '<path d="M18 6 L9 12 L18 18" stroke="currentColor" stroke-width="2.8" stroke-linecap="round" stroke-linejoin="round" fill="none"/>'
    + '<path d="M6 6v12" stroke="currentColor" stroke-width="2.8" stroke-linecap="round" fill="none"/>'
    + '</svg>';
  const ICON_PLAY = '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">'
    + '<path d="M8 5v14l11-7z" fill="currentColor"/>'
    + '</svg>';
  const ICON_PAUSE = '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">'
    + '<rect x="6" y="5" width="4" height="14" rx="1" fill="currentColor"/>'
    + '<rect x="14" y="5" width="4" height="14" rx="1" fill="currentColor"/>'
    + '</svg>';
  const ICON_NEXT = '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">'
    + '<path d="M6 6 L15 12 L6 18" stroke="currentColor" stroke-width="2.8" stroke-linecap="round" stroke-linejoin="round" fill="none"/>'
    + '<path d="M18 6v12" stroke="currentColor" stroke-width="2.8" stroke-linecap="round" fill="none"/>'
    + '</svg>';

  // Set initial icons for prev/next; play/pause will be updated by updatePlayPauseIcon()
  try { prevBtn.innerHTML = ICON_PREV; nextBtn.innerHTML = ICON_NEXT; } catch(e) {}

  // Small helper: paint the filled portion of the range input using inline background
  function updateProgressFill() {
    try {
      const val = Number(progressBar.value || 0);
      const max = Number(progressBar.max || 100);
      const pct = max > 0 ? (val / max) * 100 : 0;
      progressBar.style.background = `linear-gradient(90deg, #065F46 ${pct}%, #e6f3ea ${pct}%)`;
    } catch (e) {
      // ignore
    }
  }

  // ensure initial visual fill is correct
  try { updateProgressFill(); } catch(e) {}

    // --- Meldingen tonen in het midden bovenaan ---
function showNotification(message) {
    const box = document.createElement("div");
    box.className = "notification";
    box.textContent = message;

    document.getElementById("notification-container").appendChild(box);

    setTimeout(() => {
        box.remove();
    }, 3000);
}


  let isPlaying = false;
  let currentTrackUri = null;

  // Keep last known position/duration from player state
  let lastPosition = 0;
  let lastDuration = 0;
  let isSeeking = false;
  let progressTimer = null;

// --- LOGIN STATUS CHECK ---
function checkLoginStatus() {
    fetch("checkLogin.php")
        .then(res => res.json())
        .then(data => {
            const loginBtn = document.getElementById("login-button");
            const logoutBtn = document.getElementById("logout-button");

            if (data.loggedIn) {
                loginBtn.style.display = "none";
                logoutBtn.style.display = "inline-block";

                showNotification("Succesvol ingelogd!");
            } else {
                loginBtn.style.display = "inline-block";
                logoutBtn.style.display = "none";

                showNotification("Je bent niet ingelogd.");
            }
        });
}


checkLoginStatus();

  // --- SDK ready callback ---
  window.onSpotifyWebPlaybackSDKReady = () => {
    console.log('Spotify SDK geladen — vraag token op en initialiseer speler.');
    fetchTokenAndInitPlayer();
  };

  async function fetchTokenAndInitPlayer() {
    try {
      const res = await fetch('getToken.php', { credentials: 'include' });
      if (!res.ok) throw new Error('Niet ingelogd (status ' + res.status + ')');
      const data = await res.json();
      spotifyAccessToken = data.access_token;
      loginBtn.style.display = 'none';
      initializePlaybackSDK(spotifyAccessToken);
    } catch (err) {
      console.warn('Geen token of fout:', err);
      loginBtn.style.display = 'block';
    }
  }

  function initializePlaybackSDK(token) {
    player = new Spotify.Player({
      name: 'EuroTunes Kaart',
      getOAuthToken: cb => cb(token),
      volume: 0.5
    });

    // Ready: device_id ontvangen
    player.addListener('ready', ({ device_id }) => {
      console.log('Player ready, device id:', device_id);
      spotifyDeviceId = device_id;

      // Zorg dat playback wordt overgedragen naar deze web player (do not auto-play)
      transferPlaybackToDevice(device_id);

      // Auto-load Europe info on first load
      laadLandData('EU');
    });

    player.addListener('not_ready', ({ device_id }) => {
      console.log('Device went offline:', device_id);
    });

    player.addListener('initialization_error', ({ message }) => {
      console.error('initialization_error:', message);
    });
    player.addListener('authentication_error', ({ message }) => {
      console.error('authentication_error:', message);
      // If authentication_error happens, token may be expired. Suggest re-login.
      alert('Authenticatie fout. Log opnieuw in.');
    });
    player.addListener('account_error', ({ message }) => {
      console.error('account_error:', message);
      alert('Account probleem: Spotify Premium vereist voor playback via webplayer.');
    });

    // Beluister player state veranderingen om UI te updaten
    player.addListener('player_state_changed', state => {
      if (!state) {
        // no active playback context
        return;
      }

      // Auto-next wanneer nummer eindigt
// Detect einde nummer betrouwbaar:
// Betrouwbare auto-next detectie
if (state.duration > 0 && state.position >= state.duration - 300) {
    // voorkomt dubbele triggers
    if (!state.paused) {
        playNext();
    }
}




      const track = state.track_window?.current_track;
      if (track) {
        titleEl.textContent = track.name;
        // Truncate long artist string in JS as fallback (CSS should handle ellipsis)
        const artistStr = track.artists.map(a => a.name).join(', ');
        artistEl.textContent = artistStr.length > 60 ? artistStr.slice(0,57) + '...' : artistStr;
        coverEl.src = track.album.images[0]?.url || '';
        currentTrackUri = track.uri;
      }

      // Play / pause
      isPlaying = !state.paused;
updatePlayPauseIcon();

// Timer correct pauzeren/ hervatten
if (isPlaying) {
    startProgressTimer();   // laten doorlopen
} else {
    stopProgressTimer();    // DIRECT stoppen wanneer pauze
}


      // Update duration + position (both in ms)
      lastPosition = state.position ?? 0;
      lastDuration = state.duration ?? 0;

      // Make the progressBar use ms as units:
      // ensure the progressBar max is set to duration (ms)
      if (lastDuration > 0) {
        progressBar.max = lastDuration;
      } else {
        progressBar.max = 100; // fallback
      }

      // Only update the visual bar if user is not seeking with the slider
      if (!isSeeking) {
        progressBar.value = lastPosition;
        try { updateProgressFill(); } catch (e) {}
      }

      // small safety: start internal timer to update UI smoothly (1s intervals)
      startProgressTimer();
    });

    // Connect
    player.connect().then(success => {
      if (success) console.log('Verbonden met Spotify Player!');
    });
  }

  // Transfer playback to web player so me/player/play works for this device
  async function transferPlaybackToDevice(deviceId) {
    try {
      await fetch('https://api.spotify.com/v1/me/player', {
        method: 'PUT',
        headers: {
          'Authorization': `Bearer ${spotifyAccessToken}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ device_ids: [deviceId], play: false })
      });
      console.log('Playback overgedragen naar device:', deviceId);
    } catch (e) {
      console.error('Transfer playback error:', e);
    }
  }

  function updatePlayPauseIcon() {
    try {
      playPauseBtn.innerHTML = isPlaying ? ICON_PAUSE : ICON_PLAY;
    } catch (e) {
      // fallback to text symbols
      playPauseBtn.textContent = isPlaying ? '⏸️' : '▶️';
    }
  }

  // Play/Pause via SDK
  playPauseBtn.addEventListener('click', async () => {
    if (!player) return alert('Player niet klaar.');
    try {
      if (isPlaying) {
        await player.pause();
      } else {
        await player.resume();
      }
    } catch (e) {
      console.error('Fout bij play/pause:', e);
    }
  });

  // Prev / Next via Web API using the correct spotifyAccessToken
  prevBtn.addEventListener('click', () => {
    playPrev();
});

nextBtn.addEventListener('click', () => {
    playNext();
});


  // Progress / Seek handling (we use ms units)
  progressBar.addEventListener('pointerdown', () => {
    isSeeking = true;
    stopProgressTimer();
  });

  progressBar.addEventListener('input', () => {
    // live update position while dragging, but do not call seek yet
    // update visual fill so the left side of the thumb is colored
    updateProgressFill();
  });

  // When user releases slider (pointerup), seek to the ms position
  progressBar.addEventListener('pointerup', async () => {
    isSeeking = false;
    const ms = Number(progressBar.value);
    try {
      if (player) {
        await player.seek(ms);
      } else if (spotifyDeviceId && spotifyAccessToken) {
        // fallback: call Web API seek
        await fetch(`https://api.spotify.com/v1/me/player/seek?position_ms=${ms}&device_id=${spotifyDeviceId}`, {
          method: 'PUT',
          headers: { 'Authorization': 'Bearer ' + spotifyAccessToken }
        });
      }
    } catch (e) {
      console.error('Seek failed:', e);
    } finally {
      try { updateProgressFill(); } catch(e) {}
      startProgressTimer();
    }
  });

  // small timer to increment progressBar smoothly between player_state_changed events
  function startProgressTimer() {
    stopProgressTimer();
    const intervalMs = 50; 
    progressTimer = setInterval(() => {
      if (isPlaying && !isSeeking && lastDuration > 0) {
        lastPosition += intervalMs;
        if (lastPosition > lastDuration) lastPosition = lastDuration;
        progressBar.value = lastPosition;
        try { updateProgressFill(); } catch (e) {}
      }
    }, intervalMs);
  }

  function stopProgressTimer() {
    if (progressTimer) {
      clearInterval(progressTimer);
      progressTimer = null;
    }
  }

  // -----------------------
  // Leaflet map + load tracks
  // -----------------------
  const map = L.map('map', { doubleClickZoom: false }).setView([54, 15], 4);
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);

  let geselecteerdeLaag = null;

  // UI elements for country info
  const landNaamEl = document.getElementById('land-naam');
  const landHoofdstadEl = document.getElementById('land-hoofdstad');
  const landVlagEl = document.getElementById('land-vlag');
  const landInfoTekstEl = document.getElementById('land-info-tekst');

  fetch('europe.geojson')
    .then(response => response.json())
    .then(data => {
      L.geoJson(data, {
        style: function(feature) {
          return { fillColor: '#065f46', fillOpacity: 0, color: '#065f46', weight: 1 };
        },
        onEachFeature: function(feature, layer) {
          layer.on('click', function() {
            const landCode = feature.properties.ISO2 || feature.properties.ISO_A2 || feature.properties.iso_a2;
            if (!landCode) return console.warn('Geen landcode gevonden voor feature', feature);
            if (geselecteerdeLaag) geselecteerdeLaag.setStyle({ fillOpacity: 0, fillColor: '#065f46', color: '#065f46' });
            layer.setStyle({ fillOpacity: 0.7, fillColor: '#065f46', color: '#065f46' });
            geselecteerdeLaag = layer;
            laadLandData(landCode);
          });
        }
      }).addTo(map);
    })
    .catch(err => console.error('GeoJSON laden fout:', err));

  // Laad top 10 voor land en render UI
  async function laadLandData(code) {
    landNaamEl.innerText = 'Laden...';
    top10LijstEl.innerHTML = 'Muziek ophalen...';
    landHoofdstadEl.innerText = '';
    landVlagEl.src = '';
    landInfoTekstEl.innerText = '';

    const cacheBuster = Date.now();
    try {
      const dbRes = await fetch(`getLandInfo.php?code=${code}&_=${cacheBuster}`);
      const dbData = await dbRes.json();
      landNaamEl.innerText = dbData.naam || 'Onbekend';
      landHoofdstadEl.innerText = dbData.hoofdstad || '';
      landVlagEl.src = dbData.vlag_url || '';
      landInfoTekstEl.innerText = dbData.info_tekst || '';
    } catch (e) {
      landNaamEl.innerText = 'Data niet gevonden';
    }

    try {
      const spotifyRes = await fetch(`getTop10.php?code=${code}&_=${cacheBuster}`, { credentials: 'include' });
      const spotifyData = await spotifyRes.json();
      if (spotifyData.error) {
        top10LijstEl.innerHTML = `Fout: ${spotifyData.error}`;
        return;
      }

      queue = spotifyData.map(item => ({
    uri: item.track.uri,
    name: item.track.name,
    artist: item.track.artists.map(a => a.name).join(', '),
    cover: item.track.album?.images?.[0]?.url || ""
}));

top10LijstEl.innerHTML = "";
queue.forEach((track, index) => {
    const div = document.createElement("div");
    div.className = "song";
    div.innerHTML = `<b>${index+1}. ${track.name}</b><br><span>${track.artist}</span>`;
    div.addEventListener("click", () => {
        currentIndex = index;
        playTrack(queue[currentIndex].uri);
        highlightActive(index);
    });
    top10LijstEl.appendChild(div);
});


// --- AUTOMATISCH TOEVOEGEN AAN SPOTIFY WACHTRIJ ---
        if (spotifyDeviceId && spotifyAccessToken) {
            for (let i = 1; i < queue.length; i++) { // start bij 1, want 0 wordt direct afgespeeld
                const trackUri = queue[i].uri;
                await fetch(`https://api.spotify.com/v1/me/player/queue?uri=${trackUri}&device_id=${spotifyDeviceId}`, {
                    method: 'POST',
                    headers: { 'Authorization': `Bearer ${spotifyAccessToken}` }
                });
                console.log(`Toegevoegd aan queue: ${trackUri}`);
            }

            // Speel het eerste nummer direct
            currentIndex = 0;
            playTrack(queue[0].uri);
            highlightActive(0);
        }

    } catch (e) {
      console.error('Fout bij getTop10:', e);
      top10LijstEl.innerHTML = 'Fout bij laden van Top 10.';
    }
  }

  function highlightActive(i) {
    document.querySelectorAll(".song").forEach(el => el.classList.remove("active"));
    const songs = document.querySelectorAll(".song");
    if (songs[i]) songs[i].classList.add("active");
}

  // playTrack: start playback of a spotify:track:... uri on this device
  async function playTrack(uri) {
    if (!spotifyDeviceId) {
      alert('Spotify player nog niet klaar. Wacht even.');
      console.error('Geen spotifyDeviceId (nog niet ready).');
      return;
    }
    if (!spotifyAccessToken) {
      alert('Geen token. Log opnieuw in.');
      return;
    }

    try {
      const res = await fetch(`https://api.spotify.com/v1/me/player/play?device_id=${spotifyDeviceId}`, {
        method: 'PUT',
        headers: {
          'Authorization': `Bearer ${spotifyAccessToken}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ uris: [uri] })
      });

      if (!res.ok) {
        console.error('Playback start error, status:', res.status);
        const errText = await res.text().catch(()=>null);
        console.error('Playback error body:', errText);
        if (res.status === 403) alert('Playback mislukt: premium account vereist of device niet actief.');
        if (res.status === 404) alert('Geen actief Spotify-apparaat gevonden.');
        return;
      }

      // UI update will be handled by player_state_changed when playback actually starts
      console.log('playTrack: play request sent for', uri);

    } catch (e) {
      console.error('Netwerkfout bij playTrack:', e);
    }
  }

  async function playNext() {
    if (queue.length === 0) return;

    currentIndex = (currentIndex + 1) % queue.length;

    await playTrack(queue[currentIndex].uri);

    // UI updaten nadat playback écht gestart is
    setTimeout(() => highlightActive(currentIndex), 200);
}

async function playPrev() {
    if (queue.length === 0) return;

    currentIndex = (currentIndex - 1 + queue.length) % queue.length;

    await playTrack(queue[currentIndex].uri);

    // UI updaten nadat playback écht gestart is
    setTimeout(() => highlightActive(currentIndex), 200);
}



}); // end DOMContentLoaded
