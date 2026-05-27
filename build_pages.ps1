$content = Get-Content -Raw index.html
$split = $content -split '<!-- MAIN -->'
$baseHTML = $split[0]

$streamMain = @'
<!-- MAIN -->
<div class="main" style="display: flex; flex-direction: row !important; height: 100vh; overflow: hidden; margin-left: var(--sidebar); background: #08070d;">
  <!-- LEFT: Stream Player & Details -->
  <div style="flex: 1; display: flex; flex-direction: column; height: 100%; overflow: hidden; background: #0a0910;">
    
    <!-- Twitch-like Theater Player -->
    <div style="flex: 1; position: relative; background: #000; display: flex; align-items: center; justify-content: center; border-bottom: 1px solid var(--border); overflow: hidden;">
      <!-- Stream Video (Fits properly without cutting off, centered like a media player) -->
      <video id="streamVideo" autoplay loop muted playsinline style="width: 100%; height: 100%; object-fit: contain; z-index: 1;" poster="Assets/Vale.jpeg">
        <source src="video.mp4" type="video/mp4">
      </video>
      
      <!-- Interactive Cyberpunk Live Stream Placeholder Overlay (z-index: 3) -->
      <div id="streamPlaceholder" style="position: absolute; inset: 0; z-index: 3; display: flex; flex-direction: column; align-items: center; justify-content: center; background: rgba(8, 7, 13, 0.9); backdrop-filter: blur(12px); transition: opacity 0.8s cubic-bezier(0.4, 0, 0.2, 1); border: 1px solid rgba(255, 231, 1, 0.1); cursor: pointer;">
        <!-- Ambient blurred glowing background -->
        <div id="placeholderBg" style="position: absolute; inset: 0; background-size: cover; background-position: center; opacity: 0.15; filter: blur(40px); z-index: -1; background-image: url('Assets/Vale.jpeg');"></div>
        
        <!-- Pulsing glowing camera frame -->
        <div id="placeholderAvatar" style="width: 140px; height: 140px; border-radius: 50%; border: 3px solid var(--y); background-size: cover; background-position: center; margin-bottom: 24px; position: relative; box-shadow: var(--glow-y); background-image: url('Assets/Vale.jpeg');">
          <div style="position: absolute; bottom: -8px; left: 50%; transform: translateX(-50%); background: #ff4655; color: white; padding: 2px 8px; border-radius: 3px; font-family: 'Inter', sans-serif; font-size: 10px; font-weight: 900; letter-spacing: 0.05em; text-transform: uppercase; animation: pulse 2s infinite;">LIVE</div>
        </div>
        
        <h2 id="placeholderName" style="margin: 0; font-family: 'Inter', sans-serif; font-size: 28px; font-weight: 900; color: #fff; text-transform: uppercase; letter-spacing: 0.05em;">VALE</h2>
        <p id="placeholderStatus" style="margin: 6px 0 20px; font-size: 12px; color: var(--y); font-family: monospace; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase;">DECRYPTING TWIN FEED...</p>
        
        <!-- Live status bar -->
        <div style="display: flex; gap: 12px; align-items: center; background: rgba(255,255,255,0.05); padding: 8px 16px; border: 1px solid rgba(255,255,255,0.1); border-radius: 4px; font-size: 11px; color: #fff; font-family: monospace;">
          <span style="display: flex; align-items: center; gap: 6px; color: #ffe701; animation: pulse 1s infinite alternate;"><span style="width: 6px; height: 6px; background: #ffe701; border-radius: 50%;"></span> CONNECTING</span>
          <span style="color: rgba(255,255,255,0.3);">|</span>
          <span id="placeholderViewers">12,408 VIEWERS</span>
          <span style="color: rgba(255,255,255,0.3);">|</span>
          <span>LATENCY: -- ms</span>
        </div>
      </div>
      
      <!-- Scanline / Brutalist Grid overlay for premium twitch feel -->
      <div style="position: absolute; inset: 0; background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.25) 50%), linear-gradient(90deg, rgba(255, 0, 0, 0.06), rgba(0, 255, 0, 0.02), rgba(0, 0, 255, 0.06)); background-size: 100% 4px, 6px 100%; z-index: 2; pointer-events: none;"></div>
      
      <!-- Top Right Overlay: LIVE Tag & Expand Chat Button -->
      <div id="topRightOverlay" style="position: absolute; top: 16px; right: 16px; z-index: 10; display: flex; align-items: center; gap: 10px;">
        <div class="live-tag" style="position: static !important; background: #ff4655; color: white; padding: 4px 10px; border-radius: 4px; font-weight: 900; font-size: 11px; text-transform: uppercase; letter-spacing: 0.1em; display: flex; align-items: center; gap: 6px; animation: pulse 2s infinite;">
          <span style="width: 6px; height: 6px; background: white; border-radius: 50%;"></span>LIVE
        </div>
        <button id="expandChatBtn" onclick="openChat()" style="display: none; background: rgba(0, 0, 0, 0.75); border: 1px solid var(--border); color: #fff; padding: 8px 14px; border-radius: 4px; font-family: 'Inter', sans-serif; font-size: 11px; font-weight: 800; text-transform: uppercase; cursor: pointer; align-items: center; gap: 6px; transition: all 0.2s;" onmouseover="this.style.borderColor='var(--y)'; this.style.color='var(--y)'" onmouseout="this.style.borderColor='var(--border)'; this.style.color='#fff'">
          <span class="material-symbols-outlined" style="font-size: 14px;">chat</span> Expand Chat
        </button>
      </div>
      
      <!-- Top Left Overlay: Viewers Count -->
      <div style="position: absolute; top: 16px; left: 16px; z-index: 10;">
        <div style="background: rgba(0,0,0,0.75); padding: 4px 10px; border-radius: 4px; font-size: 11px; font-weight: 700; color: white; backdrop-filter: blur(8px); display: flex; align-items: center; gap: 6px; border: 1px solid rgba(255,255,255,0.1);">
          <span class="material-symbols-outlined" style="font-size: 14px; color: var(--y);">visibility</span>
          <span id="streamViewers">12,408</span>
        </div>
      </div>
      
      <!-- Custom Twitch Video Player Controls Overlay -->
      <div style="position: absolute; bottom: 0; left: 0; right: 0; height: 50px; background: linear-gradient(to top, rgba(0,0,0,0.85), transparent); z-index: 10; display: flex; align-items: center; justify-content: space-between; padding: 0 16px; pointer-events: auto;">
        <!-- Left Controls -->
        <div style="display: flex; align-items: center; gap: 16px; color: white;">
          <span class="material-symbols-outlined" id="streamPlayBtn" style="cursor: pointer; font-size: 20px; transition: color 0.2s;" onmouseover="this.style.color='var(--y)'" onmouseout="this.style.color='white'">pause</span>
          <div style="display: flex; align-items: center; gap: 8px;">
            <span class="material-symbols-outlined" style="cursor: pointer; font-size: 20px;" onmouseover="this.style.color='var(--y)'" onmouseout="this.style.color='white'">volume_up</span>
            <div style="width: 60px; height: 4px; background: rgba(255,255,255,0.3); border-radius: 2px; position: relative; cursor: pointer;">
              <div style="position: absolute; left: 0; top: 0; bottom: 0; width: 70%; background: var(--y); border-radius: 2px;"></div>
            </div>
          </div>
          <span style="font-size: 12px; font-family: monospace; color: rgba(255,255,255,0.7);" id="streamTimer">00:00:00</span>
        </div>
        <!-- Right Controls -->
        <div style="display: flex; align-items: center; gap: 16px; color: white;">
          <span class="material-symbols-outlined" style="cursor: pointer; font-size: 20px;" onmouseover="this.style.color='var(--y)'" onmouseout="this.style.color='white'">settings</span>
          <span class="material-symbols-outlined" style="cursor: pointer; font-size: 20px;" onmouseover="this.style.color='var(--y)'" onmouseout="this.style.color='white'">subtitles</span>
          <span class="material-symbols-outlined" style="cursor: pointer; font-size: 20px;" onmouseover="this.style.color='var(--y)'" onmouseout="this.style.color='white'">aspect_ratio</span>
          <span class="material-symbols-outlined" style="cursor: pointer; font-size: 20px;" onmouseover="this.style.color='var(--y)'" onmouseout="this.style.color='white'">fullscreen</span>
        </div>
      </div>
    </div>
    
    <!-- Twitch-like Stream Details Banner -->
    <div style="padding: 20px 24px; background: var(--bg2); display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--border); z-index: 5;">
      <div style="display: flex; align-items: center; gap: 16px;">
        <!-- Glowing Live Avatar -->
        <div id="streamAvatar" style="width: 64px; height: 64px; border-radius: 50%; border: 3px solid var(--y); background-size: cover; background-position: center; box-shadow: 0 0 15px rgba(255, 231, 1, 0.35);"></div>
        <div>
          <div style="display: flex; align-items: center; gap: 8px;">
            <h2 id="streamName" style="margin: 0; font-family: 'Inter', sans-serif; font-size: 22px; font-weight: 900; text-transform: uppercase; color: #fff; letter-spacing: -0.01em;">Vale</h2>
            <span class="material-symbols-outlined" style="font-size: 18px; color: #00ff66;" title="Verified Twin">verified</span>
          </div>
          <h3 id="streamTitle" style="margin: 4px 0 0; font-family: 'Poppins', sans-serif; font-size: 13px; font-weight: 500; color: #fff;">Q&A SESSION // CHATTING ABOUT MUSIC, LIFE & FUTURE IDEAS 🧬</h3>
          <div style="display: flex; gap: 12px; margin-top: 6px; font-size: 11px; font-weight: 600; color: var(--muted2);">
            <span>Category: <span style="color: var(--y); cursor: pointer;">Just Chatting</span></span>
            <span>•</span>
            <span style="display: flex; align-items: center; gap: 3px;"><span class="material-symbols-outlined" style="font-size: 12px;">favorite</span> <span id="followerCount">1.4M</span> Followers</span>
          </div>
        </div>
      </div>
      
      <!-- Follow/Subscribe Actions -->
      <div style="display: flex; align-items: center; gap: 12px;">
        <button id="streamFollowBtn" style="padding: 10px 18px; border-radius: 4px; border: 2px solid var(--y); background: var(--y); color: var(--blk); font-family: 'Inter', sans-serif; font-weight: 900; font-size: 12px; text-transform: uppercase; letter-spacing: 0.05em; cursor: pointer; transition: all 0.2s;">
          ♥ Follow
        </button>
        <button id="streamSubBtn" style="padding: 10px 18px; border-radius: 4px; border: 2px solid rgba(255,255,255,0.15); background: rgba(255,255,255,0.06); color: white; font-family: 'Inter', sans-serif; font-weight: 900; font-size: 12px; text-transform: uppercase; letter-spacing: 0.05em; cursor: pointer; transition: all 0.2s;" onmouseover="this.style.background='rgba(255,255,255,0.12)'" onmouseout="this.style.background='rgba(255,255,255,0.06)'">
          ⭐ Subscribe
        </button>
      </div>
    </div>
  </div>

  <!-- RIGHT: Twitch Live Chat (contained) -->
  <div id="streamChatPanel" style="width: 360px; display: flex; flex-direction: column; background: var(--bg); border-left: 1px solid var(--border); height: 100%;">
    <!-- Chat Header -->
    <div style="padding: 16px 20px; border-bottom: 1px solid var(--border); background: var(--card); display: flex; align-items: center; justify-content: space-between;">
      <h3 style="margin: 0; font-family: 'Inter', sans-serif; font-size: 13px; font-weight: 900; text-transform: uppercase; letter-spacing: 0.05em; color: #fff; display: flex; align-items: center; gap: 8px;">
        <span style="display: inline-block; width: 6px; height: 6px; border-radius: 50%; background: #ff4655; animation: pulse 1s infinite alternate;"></span> Stream Chat
      </h3>
      <span class="material-symbols-outlined" style="color: var(--muted); cursor: pointer; transition: color 0.2s; font-size: 18px;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='var(--muted)'" onclick="closeChat()">close</span>
    </div>
    
    <!-- Chat Messages scrolling pane -->
    <div id="streamChatBody" style="flex: 1; overflow-y: auto; padding: 20px; display: flex; flex-direction: column; gap: 14px; background: rgba(0,0,0,0.15);">
      <!-- Simulated Chat Messages with Badges -->
      <div style="font-size: 12px; line-height: 1.6; word-break: break-word;">
        <span style="background: var(--y); color: var(--blk); padding: 1px 4px; border-radius: 2px; font-weight: 800; font-size: 9px; text-transform: uppercase; margin-right: 4px;">VIP</span>
        <span style="color: #ff9933; font-weight: 700; margin-right: 6px;">NeonNinja:</span>How do you even do that? Amazing stream!
      </div>
      <div style="font-size: 12px; line-height: 1.6; word-break: break-word;">
        <span style="background: #a970ff; color: white; padding: 1px 4px; border-radius: 2px; font-weight: 800; font-size: 9px; text-transform: uppercase; margin-right: 4px;">SUB</span>
        <span style="color: #00ff66; font-weight: 700; margin-right: 6px;">CryptoKing:</span>LFG! Vale is literally cooking today 🍳🔥
      </div>
      <div style="font-size: 12px; line-height: 1.6; word-break: break-word;">
        <span style="color: #4d94ff; font-weight: 700; margin-right: 6px;">AliceGamer:</span>Anyone else listening to this in background while building?
      </div>
      <div style="font-size: 12px; line-height: 1.6; word-break: break-word;">
        <span style="background: #ff4655; color: white; padding: 1px 4px; border-radius: 2px; font-weight: 800; font-size: 9px; text-transform: uppercase; margin-right: 4px;">MOD</span>
        <span style="color: #ff4d4d; font-weight: 700; margin-right: 6px;">CyberGuard:</span>Be respectful in chat guys! Keep the vibes high.
      </div>
      <div style="font-size: 12px; line-height: 1.6; word-break: break-word;">
        <span style="color: #cc33ff; font-weight: 700; margin-right: 6px;">ZeroCool:</span>Best digital twin out there no cap.
      </div>
    </div>
    
    <!-- Chat Input Area -->
    <div style="padding: 16px 20px; border-top: 1px solid var(--border); background: var(--bg2);">
      <div style="display: flex; flex-direction: column; gap: 8px;">
        <div style="display: flex; gap: 8px; align-items: center; position: relative;">
          <input type="text" id="streamChatInput" placeholder="Send a message..." maxlength="150" style="flex: 1; padding: 10px 14px; border-radius: 4px; border: 1px solid var(--border); background: rgba(0,0,0,0.25); color: #fff; font-family: 'Poppins', sans-serif; font-size: 12px; outline: none; transition: border-color 0.2s;" onfocus="this.style.borderColor='var(--y)'" onblur="this.style.borderColor='var(--border)'">
          <button id="streamSendBtn" style="padding: 10px 16px; border-radius: 4px; border: none; background: #a970ff; color: white; font-family: 'Inter', sans-serif; font-weight: 900; font-size: 12px; cursor: pointer; transition: background 0.2s;" onmouseover="this.style.background='#8c44f7'" onmouseout="this.style.background='#a970ff'">
            Chat
          </button>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: center; font-size: 10px; color: var(--muted2);">
          <span style="display: flex; align-items: center; gap: 4px; cursor: pointer;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='var(--muted2)'">
            <span class="material-symbols-outlined" style="font-size: 12px;">toll</span> Get Coins
          </span>
          <span id="chatCharLimit">0/150</span>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  // Chat window collapse logic
  window.closeChat = function() {
    const chatPanel = document.getElementById('streamChatPanel');
    const expandBtn = document.getElementById('expandChatBtn');
    if (chatPanel) chatPanel.style.display = 'none';
    if (expandBtn) expandBtn.style.display = 'flex';
  };

  window.openChat = function() {
    const chatPanel = document.getElementById('streamChatPanel');
    const expandBtn = document.getElementById('expandChatBtn');
    if (chatPanel) chatPanel.style.display = 'flex';
    if (expandBtn) expandBtn.style.display = 'none';
  };

  // Clean up and override sidebar event listeners to prevent errors
  const oldSidebar = document.querySelector('.sidebar');
  if (oldSidebar) {
    const newSidebar = oldSidebar.cloneNode(true);
    oldSidebar.parentNode.replaceChild(newSidebar, oldSidebar);
    
    // Add routing to new sidebar items
    newSidebar.querySelectorAll('.sb-item').forEach(item => {
      item.addEventListener('click', () => {
        const labelSpan = item.querySelector('span:not(.sb-icon):not(.sb-badge)');
        if (labelSpan) {
          const label = labelSpan.textContent.toLowerCase();
          if (label === 'home') {
            window.location.href = 'index.html';
          } else if (label === 'feed') {
            window.location.href = 'index.html?section=feed';
          } else if (label === 'chat') {
            window.location.href = 'index.html?section=chat';
          } else if (label === 'live') {
            window.location.href = 'index.html?section=live';
          } else if (label === 'collection') {
            window.location.href = 'create-avatar.html';
          } else if (label === 'create character') {
            window.location.href = 'create-avatar.html';
          } else {
            window.location.href = 'index.html';
          }
        }
      });
    });
  }

  // Populate from URL parameters
  const urlParams = new URLSearchParams(window.location.search);
  const name = urlParams.get('name') || 'Vale';
  const imgUrl = urlParams.get('img') || 'Assets/Vale.jpeg';
  
  document.getElementById('streamName').textContent = name;
  document.getElementById('streamAvatar').style.backgroundImage = 'url("' + imgUrl + '")';
  
  // Set up placeholder elements
  document.getElementById('placeholderName').textContent = name;
  document.getElementById('placeholderAvatar').style.backgroundImage = 'url("' + imgUrl + '")';
  document.getElementById('placeholderBg').style.backgroundImage = 'url("' + imgUrl + '")';

  const streamVideo = document.getElementById('streamVideo');
  if (streamVideo) {
    streamVideo.poster = imgUrl;
    streamVideo.load();
  }

  // Live Stream Placeholder Connection Animation
  const placeholder = document.getElementById('streamPlaceholder');
  const placeholderStatus = document.getElementById('placeholderStatus');
  const placeholderViewers = document.getElementById('placeholderViewers');

  setTimeout(() => {
    if (placeholderStatus) {
      placeholderStatus.textContent = "SIGNAL FEED SECURED // DOUBLE-CLICK PLAYER TO RESUME";
      placeholderStatus.style.color = "var(--y)";
    }
  }, 1000);

  // Toggle placeholder overlay on click
  if (placeholder) {
    placeholder.addEventListener('click', () => {
      placeholder.style.opacity = '0';
      setTimeout(() => { placeholder.style.display = 'none'; }, 800);
      if (streamVideo) {
        streamVideo.play().catch(e => console.log('Play failed:', e));
      }
    });
  }

  // Title variations based on Twin
  const titles = {
    'Vale': 'Q&A SESSION // CHATTING ABOUT MUSIC, LIFE & FUTURE IDEAS 🧬',
    'Serena': 'LIVE WELLNESS COACHING & STRESS RECOVERY WORKSHOP 🧘‍♀️',
    'Rina L.': 'CYBER-BUILDERNO SESSION [LIVE FROM NEO-TOKYO] 🌌',
    'Aiko': 'TRACK TRAINING COMPILATION // RACE PREP & Q&A 🏃‍♀️',
    'Cody': 'CRYPTO INSIGHTS, WEB3 ALPHA & RWA STABLECOIN DEBATE 🪙'
  };
  const streamTitle = document.getElementById('streamTitle');
  if (streamTitle) {
    streamTitle.textContent = titles[name] || `LIVE SESSION with ${name.toUpperCase()} // CHATTING & HANGING OUT 🌟`;
  }

  // Live Followers & Viewers Randomizer
  const streamViewers = document.getElementById('streamViewers');
  if (streamViewers) {
    const minViewers = 5000;
    const maxViewers = 48000;
    const viewersVal = Math.floor(Math.random() * (maxViewers - minViewers) + minViewers);
    streamViewers.textContent = viewersVal.toLocaleString();
    if (placeholderViewers) {
      placeholderViewers.textContent = viewersVal.toLocaleString() + " VIEWERS";
    }
  }

  // Stream Player Timer
  const streamTimer = document.getElementById('streamTimer');
  if (streamTimer) {
    let seconds = 0;
    setInterval(() => {
      seconds++;
      const hrs = String(Math.floor(seconds / 3600)).padStart(2, '0');
      const mins = String(Math.floor((seconds % 3600) / 60)).padStart(2, '0');
      const secs = String(seconds % 60).padStart(2, '0');
      streamTimer.textContent = `${hrs}:${mins}:${secs}`;
    }, 1000);
  }

  // Play/Pause controls button
  const playBtn = document.getElementById('streamPlayBtn');
  if (playBtn && streamVideo) {
    playBtn.addEventListener('click', () => {
      if (streamVideo.paused) {
        streamVideo.play();
        playBtn.textContent = 'pause';
      } else {
        streamVideo.pause();
        playBtn.textContent = 'play_arrow';
      }
    });
  }

  // Follow Button Action
  const followBtn = document.getElementById('streamFollowBtn');
  const followerCount = document.getElementById('followerCount');
  if (followBtn) {
    let following = false;
    followBtn.addEventListener('click', () => {
      following = !following;
      if (following) {
        followBtn.textContent = '✓ Following';
        followBtn.style.background = 'rgba(255,255,255,0.1)';
        followBtn.style.color = 'white';
        followBtn.style.borderColor = 'var(--border)';
        if (followerCount) {
          const val = (parseFloat(followerCount.textContent) + 0.1).toFixed(1);
          followerCount.textContent = val + 'M';
        }
      } else {
        followBtn.textContent = '♥ Follow';
        followBtn.style.background = 'var(--y)';
        followBtn.style.color = 'var(--blk)';
        followBtn.style.borderColor = 'var(--y)';
        if (followerCount) {
          const val = (parseFloat(followerCount.textContent) - 0.1).toFixed(1);
          followerCount.textContent = val + 'M';
        }
      }
    });
  }

  // Stream chat logic
  const streamInput = document.getElementById('streamChatInput');
  const streamSendBtn = document.getElementById('streamSendBtn');
  const streamChatBody = document.getElementById('streamChatBody');
  const chatCharLimit = document.getElementById('chatCharLimit');

  // Input Character Count limit
  if (streamInput && chatCharLimit) {
    streamInput.addEventListener('input', () => {
      chatCharLimit.textContent = `${streamInput.value.length}/150`;
    });
  }

  function sendStreamMsg() {
    const text = streamInput.value.trim();
    if (!text) return;

    const msgHtml = `<div style="font-size: 12px; line-height: 1.6; word-break: break-word; animation: fadeIn 0.3s ease;">
      <span style="background: #a970ff; color: white; padding: 1px 4px; border-radius: 2px; font-weight: 800; font-size: 9px; text-transform: uppercase; margin-right: 4px;">YOU</span>
      <span style="color: #00ff66; font-weight: 700; margin-right: 6px;">You:</span>
      ` + text + `
    </div>`;
    streamChatBody.insertAdjacentHTML('beforeend', msgHtml);
    streamInput.value = '';
    if (chatCharLimit) chatCharLimit.textContent = '0/150';
    streamChatBody.scrollTop = streamChatBody.scrollHeight;
  }

  if (streamSendBtn) streamSendBtn.addEventListener('click', sendStreamMsg);
  if (streamInput) {
    streamInput.addEventListener('keypress', e => {
      if (e.key === 'Enter') sendStreamMsg();
    });
  }

  // Highlight sidebar
  document.querySelectorAll('.sb-item').forEach(i => i.classList.remove('active'));
  const sbLiveItem = document.getElementById('sbLive');
  if (sbLiveItem) sbLiveItem.classList.add('active');

  // Simulated live chat comment generation from active community
  const users = ['NeonNinja', 'CryptoKing', 'AliceGamer', 'CyberGuard', 'ZeroCool', 'DopeLover', 'TwinFanatic', 'SolanaSlinger', 'PixelArt', 'MetaRacer'];
  const badges = ['VIP', 'SUB', 'MOD', ''];
  const messages = [
    'Wait, that is actually crazy!',
    'Can we talk about the new album? It is insane 😭',
    'What do you think of neural twin expansion?',
    'Lmao true, no cap',
    'She is so beautiful and smart!',
    'Is this streamed from Neo-Tokyo or Singapore?',
    'OMG notice me!',
    'This is next-level tech. Wowed.',
    'Subscribed today! Best value ever.',
    'Wait, tell me more about that category'
  ];
  
  setInterval(() => {
    const randomUser = users[Math.floor(Math.random() * users.length)];
    const randomBadge = badges[Math.floor(Math.random() * badges.length)];
    const randomMsg = messages[Math.floor(Math.random() * messages.length)];
    
    let badgeHtml = '';
    if (randomBadge) {
      let badgeBg = 'var(--y)';
      let badgeColor = 'var(--blk)';
      if (randomBadge === 'SUB') { badgeBg = '#a970ff'; badgeColor = 'white'; }
      if (randomBadge === 'MOD') { badgeBg = '#ff4655'; badgeColor = 'white'; }
      badgeHtml = `<span style="background: ${badgeBg}; color: ${badgeColor}; padding: 1px 4px; border-radius: 2px; font-weight: 800; font-size: 9px; text-transform: uppercase; margin-right: 4px;">${randomBadge}</span>`;
    }
    
    const msgHtml = `<div style="font-size: 12px; line-height: 1.6; word-break: break-word; animation: fadeIn 0.3s ease;">
      ${badgeHtml}
      <span style="color: ${randomUser === 'CyberGuard' ? '#ff4d4d' : '#ffe701'}; font-weight: 700; margin-right: 6px;">${randomUser}:</span>
      ${randomMsg}
    </div>`;
    
    if (streamChatBody) {
      streamChatBody.insertAdjacentHTML('beforeend', msgHtml);
      if (streamChatBody.children.length > 50) {
        streamChatBody.children[0].remove();
      }
      streamChatBody.scrollTop = streamChatBody.scrollHeight;
    }
  }, 3000);
</script>
</body>
</html>
'@

$chatMain = @'
<!-- MAIN -->
<div class="main" style="display: flex; height: 100vh; overflow: hidden; background: var(--bg); margin-left: var(--sidebar);">
  <!-- Full Width Chat Pane -->
  <div style="width: 100%; height: 100%; display: flex; flex-direction: column; background: var(--bg2); position: relative;">
    
    <div style="padding: 20px 30px; border-bottom: 1px solid var(--border); background: var(--bg); display: flex; align-items: center; justify-content: space-between; z-index: 10; box-shadow: 0 4px 20px rgba(0,0,0,0.3);">
      <div style="display: flex; align-items: center; gap: 20px;">
        <span class="material-symbols-outlined" style="cursor: pointer; color: var(--muted); transition: color 0.2s;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='var(--muted)'" onclick="window.location.href='index.html'">arrow_back</span>
        <div id="chatAvatar" style="width: 48px; height: 48px; border-radius: 50%; border: 2px solid var(--y); background-size: cover; background-position: center;"></div>
        <div>
          <h3 id="chatName" style="margin: 0; font-family: 'Inter', sans-serif; font-size: 18px; font-weight: 800; color: #fff; letter-spacing: -0.01em;">Twin Name</h3>
          <p style="margin: 4px 0 0; font-size: 11px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; color: #00ff66; display: flex; align-items: center; gap: 6px;">
            <span style="display: inline-block; width: 6px; height: 6px; border-radius: 50%; background: #00ff66; box-shadow: 0 0 8px #00ff66;"></span> Online
          </p>
        </div>
      </div>
      <div style="display: flex; gap: 24px; color: var(--muted);">
        <span class="material-symbols-outlined" onclick="startFacetimeCall('audio')" style="cursor: pointer; transition: color 0.2s;" onmouseover="this.style.color='var(--y)'" onmouseout="this.style.color='var(--muted)'">call</span>
        <span class="material-symbols-outlined" onclick="startFacetimeCall('video')" style="cursor: pointer; transition: color 0.2s;" onmouseover="this.style.color='var(--y)'" onmouseout="this.style.color='var(--muted)'">videocam</span>
        <span class="material-symbols-outlined" style="cursor: pointer; transition: color 0.2s;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='var(--muted)'">more_vert</span>
      </div>
    </div>

    <!-- Chat History -->
    <div id="chatHistory" style="flex: 1; overflow-y: auto; padding: 40px 30px; display: flex; flex-direction: column; gap: 24px; background-image: radial-gradient(rgba(255,255,255,0.02) 1px, transparent 1px); background-size: 20px 20px;">
      <div style="text-align: center; font-size: 11px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.1em; color: var(--muted); margin-bottom: 20px;">Today</div>
      <!-- Messages injected by JS -->
    </div>

    <!-- Chat Input Area -->
    <div style="padding: 24px 30px; border-top: 1px solid var(--border); background: var(--bg);">
      <div style="display: flex; align-items: center; gap: 16px; background: rgba(255,255,255,0.03); padding: 12px 20px; border-radius: 30px; border: 1px solid var(--border); box-shadow: inset 0 2px 10px rgba(0,0,0,0.2);">
        <span class="material-symbols-outlined" style="color: var(--muted); cursor: pointer; transition: color 0.2s;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='var(--muted)'">add_circle</span>
        <input type="text" id="mainChatInput" placeholder="Message your twin..." style="flex: 1; border: none; background: transparent; color: #fff; font-family: 'Poppins', sans-serif; font-size: 14px; outline: none;">
        <span class="material-symbols-outlined" style="color: var(--muted); cursor: pointer; transition: color 0.2s;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='var(--muted)'">mic</span>
        <button id="mainSendBtn" style="border: none; background: transparent; color: var(--y); display: flex; align-items: center; justify-content: center; cursor: pointer; padding: 0; transition: transform 0.2s;" onmouseover="this.style.transform='scale(1.1)'" onmouseout="this.style.transform='scale(1)'">
          <span class="material-symbols-outlined" style="font-size: 24px;">send</span>
        </button>
      </div>
    </div>

    <!-- Beautiful Fullscreen FaceTime Overlay -->
    <div id="videoCallOverlay" style="display: none; position: absolute; inset: 0; background: #050408; z-index: 100; flex-direction: column; justify-content: space-between; overflow: hidden; animation: zoomIn 0.3s ease-out; font-family: 'Poppins', sans-serif;">
      <!-- Looping Video of Twin (Background) -->
      <video id="facetimeVideo" loop muted playsinline style="position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; z-index: 1;">
        <source src="video.mp4" type="video/mp4">
      </video>
      
      <!-- Backdrop cover (if video fails or is in audio-only call) -->
      <div id="facetimePhotoBackdrop" style="position: absolute; inset: 0; background-size: cover; background-position: center; filter: brightness(0.4); z-index: 1; display: none;"></div>

      <!-- User PIP Camera (Top Right) -->
      <div style="position: absolute; top: 30px; right: 30px; width: 120px; height: 160px; border-radius: 12px; border: 2px solid rgba(255,255,255,0.2); overflow: hidden; z-index: 10; box-shadow: 0 10px 30px rgba(0,0,0,0.5); background: #111;">
        <video id="userPipVideo" autoplay playsinline muted style="width: 100%; height: 100%; object-fit: cover; transform: scaleX(-1);"></video>
        <!-- fallback avatar if camera is not active -->
        <div id="userPipFallback" style="position: absolute; inset: 0; display: flex; align-items: center; justify-content: center; background: #181627; color: rgba(255,255,255,0.4);">
          <span class="material-symbols-outlined" style="font-size: 32px;">person</span>
        </div>
      </div>

      <!-- Top bar (Connection info) -->
      <div style="position: relative; z-index: 10; padding: 30px; display: flex; align-items: center; justify-content: space-between; background: linear-gradient(to bottom, rgba(0,0,0,0.7) 0%, transparent 100%);">
        <div style="display: flex; align-items: center; gap: 14px;">
          <div id="facetimeAvatar" style="width: 44px; height: 44px; border-radius: 50%; border: 2px solid var(--y); background-size: cover; background-position: center; background-color: var(--card);"></div>
          <div>
            <h4 id="facetimeName" style="margin: 0; font-family: 'Outfit', sans-serif; font-size: 16px; font-weight: 800; color: #fff; text-transform: uppercase; letter-spacing: 0.05em;">Aria Sterling</h4>
            <div style="font-size: 10px; color: #00ff66; font-weight: 700; letter-spacing: 0.05em; text-transform: uppercase; display: flex; align-items: center; gap: 5px;">
              <span style="display: inline-block; width: 5px; height: 5px; border-radius: 50%; background: #00ff66; box-shadow: 0 0 6px #00ff66; animation: pulse 1s infinite alternate;"></span> Connected
            </div>
          </div>
        </div>
        <div style="font-family: monospace; font-size: 11px; color: rgba(255,255,255,0.7); background: rgba(0,0,0,0.5); padding: 6px 12px; border-radius: 12px; border: 1px solid rgba(255,255,255,0.1);">
          TIME: <span id="facetimeTimerVal">00:00</span>
        </div>
      </div>

      <!-- Bottom Subtitles & Interactive Keyboard Overlay -->
      <div style="position: relative; z-index: 10; display: flex; flex-direction: column; align-items: center; gap: 20px; background: linear-gradient(to top, rgba(0,0,0,0.85) 0%, transparent 100%); padding: 30px;">
        <!-- Subtitles Card (Showing speech) -->
        <div style="background: rgba(16, 14, 27, 0.75); backdrop-filter: blur(15px); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 16px; padding: 16px 24px; max-width: 600px; width: 90%; text-align: center; box-shadow: 0 10px 40px rgba(0,0,0,0.5);">
          <p id="facetimeSubtitles" style="margin: 0; font-family: 'Poppins', sans-serif; font-size: 14px; line-height: 1.6; color: #fff; font-style: italic;">
            "Hey! It's so incredible to see you face-to-face. I'm listening..."
          </p>
        </div>

        <!-- Sleek text input for call-chatting -->
        <div style="display: flex; align-items: center; gap: 12px; width: 90%; max-width: 500px; background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.15); padding: 8px 16px; border-radius: 24px; backdrop-filter: blur(10px);">
          <input type="text" id="facetimeMsgInput" placeholder="Say something to your twin..." style="flex:1; background: transparent; border:none; color:#fff; font-family: 'Poppins', sans-serif; font-size:13px; outline:none;">
          <button onclick="sendFacetimeChatMsg()" style="background: transparent; border: none; color: var(--y); cursor: pointer; display: flex; align-items: center;">
            <span class="material-symbols-outlined" style="font-size: 20px;">send</span>
          </button>
        </div>

        <!-- Glassmorphic FaceTime Call Control Bar -->
        <div style="display: flex; align-items: center; gap: 20px; margin-top: 10px;">
          <!-- Mic mute button -->
          <button id="btnFacetimeMute" onclick="toggleFacetimeMute()" style="width: 48px; height: 48px; border-radius: 50%; background: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.15); color: #fff; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: background 0.2s;" onmouseover="this.style.background='rgba(255,255,255,0.2)'" onmouseout="this.style.background='rgba(255,255,255,0.1)'">
            <span class="material-symbols-outlined" id="facetimeMuteIcon">mic</span>
          </button>
          
          <!-- END CALL BUTTON -->
          <button onclick="endFacetimeCall()" style="width: 56px; height: 56px; border-radius: 50%; background: #ff3b30; border: none; color: #fff; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: transform 0.2s, box-shadow 0.2s; box-shadow: 0 4px 15px rgba(255,59,48,0.4);" onmouseover="this.style.transform='scale(1.1)'" onmouseout="this.style.transform='scale(1)'">
            <span class="material-symbols-outlined" style="font-size: 28px;">call_end</span>
          </button>

          <!-- Camera toggle button -->
          <button id="btnFacetimeCam" onclick="toggleFacetimeCam()" style="width: 48px; height: 48px; border-radius: 50%; background: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.15); color: #fff; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: background 0.2s;" onmouseover="this.style.background='rgba(255,255,255,0.2)'" onmouseout="this.style.background='rgba(255,255,255,0.1)'">
            <span class="material-symbols-outlined" id="facetimeCamIcon">videocam</span>
          </button>
        </div>
      </div>
    </div>
    
  </div>
</div>

<style>
  /* Extra Chat Styles */
  .msg-bubble {
    max-width: 75%;
    padding: 14px 20px;
    font-size: 14px;
    line-height: 1.5;
    border-radius: 20px;
    animation: slideUp 0.3s ease-out;
    position: relative;
  }
  .msg-bubble.ai {
    background: var(--card);
    color: #fff;
    border: 1px solid var(--border);
    border-bottom-left-radius: 4px;
    align-self: flex-start;
  }
  .msg-bubble.user {
    background: var(--y);
    color: var(--blk);
    font-weight: 500;
    border-bottom-right-radius: 4px;
    align-self: flex-end;
  }
  @keyframes slideUp {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
  }
  @keyframes zoomIn {
    from { opacity: 0; transform: scale(1.05); }
    to { opacity: 1; transform: scale(1); }
  }
</style>

<script>
  // Clean up and override sidebar event listeners to prevent errors
  const oldSidebar = document.querySelector('.sidebar');
  if (oldSidebar) {
    const newSidebar = oldSidebar.cloneNode(true);
    oldSidebar.parentNode.replaceChild(newSidebar, oldSidebar);
    
    // Add routing to new sidebar items
    newSidebar.querySelectorAll('.sb-item').forEach(item => {
      item.addEventListener('click', () => {
        const labelSpan = item.querySelector('span:not(.sb-icon):not(.sb-badge)');
        if (labelSpan) {
          const label = labelSpan.textContent.toLowerCase();
          if (label === 'home') {
            window.location.href = 'index.html';
          } else if (label === 'feed') {
            window.location.href = 'index.html?section=feed';
          } else if (label === 'chat') {
            window.location.href = 'index.html?section=chat';
          } else if (label === 'live') {
            window.location.href = 'index.html?section=live';
          } else if (label === 'collection') {
            window.location.href = 'create-avatar.html';
          } else if (label === 'create character') {
            window.location.href = 'create-avatar.html';
          } else {
            window.location.href = 'index.html';
          }
        }
      });
    });
  }

  const urlParams = new URLSearchParams(window.location.search);
  const name = urlParams.get('name') || 'Twin';
  const imgUrl = urlParams.get('img') || 'Assets/Vale.jpeg';
  
  document.getElementById('chatName').textContent = name;
  document.getElementById('chatAvatar').style.backgroundImage = 'url("' + imgUrl + '")';

  const chatHistory = document.getElementById('chatHistory');
  const chatInput = document.getElementById('mainChatInput');
  const sendBtn = document.getElementById('mainSendBtn');

  // Initial greeting
  setTimeout(() => {
    chatHistory.innerHTML += '<div class="msg-bubble ai">Hey! I\'m ' + name.split(' ')[0] + '. So glad you\'re here. What\'s on your mind today?</div>';
  }, 400);

  function sendChatMsg() {
    const text = chatInput.value.trim();
    if (!text) return;

    chatHistory.insertAdjacentHTML('beforeend', '<div class="msg-bubble user">' + text + '</div>');
    chatInput.value = '';
    chatHistory.scrollTop = chatHistory.scrollHeight;

    // Simulate AI response
    setTimeout(() => {
      chatHistory.insertAdjacentHTML('beforeend', '<div class="msg-bubble ai"><span style="display:inline-block; width:4px; height:4px; background:var(--muted); border-radius:50%; margin:2px; animation: pulse 1s infinite alternate;"></span><span style="display:inline-block; width:4px; height:4px; background:var(--muted); border-radius:50%; margin:2px; animation: pulse 1s infinite alternate 0.2s;"></span><span style="display:inline-block; width:4px; height:4px; background:var(--muted); border-radius:50%; margin:2px; animation: pulse 1s infinite alternate 0.4s;"></span></div>');
      chatHistory.scrollTop = chatHistory.scrollHeight;
      
      setTimeout(() => {
        chatHistory.lastChild.remove();
        const responses = [
          "That's so interesting, tell me more!",
          "Haha, I totally get what you mean.",
          "Wow, seriously?",
          "I was just thinking about that.",
          "You always know what to say."
        ];
        const res = responses[Math.floor(Math.random() * responses.length)];
        chatHistory.insertAdjacentHTML('beforeend', '<div class="msg-bubble ai">' + res + '</div>');
        chatHistory.scrollTop = chatHistory.scrollHeight;
      }, 1500);
    }, 500);
  }

  sendBtn.addEventListener('click', sendChatMsg);
  chatInput.addEventListener('keypress', e => {
    if (e.key === 'Enter') sendChatMsg();
  });
  
  // Highlight sidebar
  document.querySelectorAll('.sb-item').forEach(i => i.classList.remove('active'));
  const sbItems = document.querySelectorAll('.sb-item');
  if (sbItems.length > 2) sbItems[2].classList.add('active'); // Chat is index 2

  // ══════════════════════════════════
  // PREMIUM FACETIME VIDEO CALL SYSTEM
  // ══════════════════════════════════
  let facetimeTimer = null;
  let facetimeSeconds = 0;
  let facetimeStream = null;
  let isFacetimeMuted = false;
  let isFacetimeCamOff = false;

  window.startFacetimeCall = function(mode = 'video') {
    const overlay = document.getElementById('videoCallOverlay');
    const fAvatar = document.getElementById('facetimeAvatar');
    const fName = document.getElementById('facetimeName');
    const fVideo = document.getElementById('facetimeVideo');
    const fBackdrop = document.getElementById('facetimePhotoBackdrop');
    const timerVal = document.getElementById('facetimeTimerVal');
    const subtitles = document.getElementById('facetimeSubtitles');
    
    // Set identity details from parameters
    fName.textContent = name;
    fAvatar.style.backgroundImage = 'url("' + imgUrl + '")';
    fBackdrop.style.backgroundImage = 'url("' + imgUrl + '")';

    // Show FaceTime layout
    overlay.style.display = 'flex';
    
    // Set call mode styling
    if (mode === 'audio') {
      fVideo.style.display = 'none';
      fBackdrop.style.display = 'block';
      subtitles.textContent = `"${name.split(' ')[0]} is on the line. I'm listening..."`;
    } else {
      fVideo.style.display = 'block';
      fBackdrop.style.display = 'none';
      subtitles.textContent = `"Hey! It's so incredible to see you face-to-face. I'm listening..."`;
      
      // Start looping FaceTime video player
      fVideo.play().catch(err => {
        console.log("FaceTime video autoplay failed, falling back to profile image:", err);
        fVideo.style.display = 'none';
        fBackdrop.style.display = 'block';
      });
    }

    // Attempt to request user webcam feed for PIP display
    const userVideo = document.getElementById('userPipVideo');
    const fallback = document.getElementById('userPipFallback');
    
    navigator.mediaDevices.getUserMedia({ video: true, audio: false })
      .then(stream => {
        facetimeStream = stream;
        userVideo.srcObject = stream;
        fallback.style.display = 'none';
      })
      .catch(err => {
        console.warn("User camera access declined or unavailable for PIP:", err);
        fallback.style.display = 'flex';
      });

    // Start Call Timer
    facetimeSeconds = 0;
    timerVal.textContent = "00:00";
    facetimeTimer = setInterval(() => {
      facetimeSeconds++;
      const m = Math.floor(facetimeSeconds / 60).toString().padStart(2, '0');
      const s = (facetimeSeconds % 60).toString().padStart(2, '0');
      timerVal.textContent = `${m}:${s}`;
    }, 1000);

    // Initial greeting audio trigger (simulation)
    if (window.speechSynthesis) {
      window.speechSynthesis.cancel();
      const txt = mode === 'audio' ? `Hey! I'm on the line. So glad we can speak!` : `Hey! It is so incredible to see you face to face. So glad we can speak!`;
      const utterance = new SpeechSynthesisUtterance(txt);
      utterance.rate = 1.0;
      utterance.pitch = 1.05;
      window.speechSynthesis.speak(utterance);
    }
  }

  window.endFacetimeCall = function() {
    // Hide overlay
    document.getElementById('videoCallOverlay').style.display = 'none';
    
    // Stop timers
    if (facetimeTimer) {
      clearInterval(facetimeTimer);
      facetimeTimer = null;
    }

    // Stop looping video
    const fVideo = document.getElementById('facetimeVideo');
    fVideo.pause();

    // Release user camera stream
    if (facetimeStream) {
      facetimeStream.getTracks().forEach(track => track.stop());
      facetimeStream = null;
    }
    
    const userVideo = document.getElementById('userPipVideo');
    userVideo.srcObject = null;

    if (window.speechSynthesis) {
      window.speechSynthesis.cancel();
    }
  }

  window.toggleFacetimeMute = function() {
    isFacetimeMuted = !isFacetimeMuted;
    const btn = document.getElementById('btnFacetimeMute');
    const icon = document.getElementById('facetimeMuteIcon');
    if (isFacetimeMuted) {
      btn.style.background = '#ff3b30';
      icon.textContent = 'mic_off';
    } else {
      btn.style.background = 'rgba(255,255,255,0.1)';
      icon.textContent = 'mic';
    }
  }

  window.toggleFacetimeCam = function() {
    isFacetimeCamOff = !isFacetimeCamOff;
    const btn = document.getElementById('btnFacetimeCam');
    const icon = document.getElementById('facetimeCamIcon');
    const fallback = document.getElementById('userPipFallback');
    
    if (facetimeStream) {
      facetimeStream.getVideoTracks().forEach(t => t.enabled = !isFacetimeCamOff);
    }
    
    if (isFacetimeCamOff) {
      btn.style.background = '#ff9500';
      icon.textContent = 'videocam_off';
      fallback.style.display = 'flex';
    } else {
      btn.style.background = 'rgba(255,255,255,0.1)';
      icon.textContent = 'videocam';
      if (facetimeStream) fallback.style.display = 'none';
    }
  }

  window.sendFacetimeChatMsg = function() {
    const input = document.getElementById('facetimeMsgInput');
    const text = input.value.trim();
    if (!text) return;

    input.value = '';
    
    // Display what user typed in subtitles
    const subtitles = document.getElementById('facetimeSubtitles');
    subtitles.innerHTML = `<span style="opacity: 0.6;">You said:</span> "${text}"`;

    // Append message to standard chat background list so conversation preserves
    chatHistory.insertAdjacentHTML('beforeend', '<div class="msg-bubble user">' + text + '</div>');
    chatHistory.scrollTop = chatHistory.scrollHeight;

    // Simulate response with speech synthesis & subtitle update
    setTimeout(() => {
      subtitles.textContent = "...";
      
      setTimeout(() => {
        const responses = [
          "That's so interesting, tell me more!",
          "Haha, I totally get what you mean.",
          "Wow, seriously?",
          "I was just thinking about that.",
          "You always know what to say."
        ];
        const res = responses[Math.floor(Math.random() * responses.length)];
        
        // Show subtitle response
        subtitles.innerHTML = `"${res}"`;
        
        // Speak response out loud using native Web Speech Synthesis
        if (window.speechSynthesis) {
          window.speechSynthesis.cancel();
          const utterance = new SpeechSynthesisUtterance(res);
          utterance.rate = 1.0;
          utterance.pitch = 1.05;
          window.speechSynthesis.speak(utterance);
        }

        // Add response to underlying text chat history
        chatHistory.insertAdjacentHTML('beforeend', '<div class="msg-bubble ai">' + res + '</div>');
        chatHistory.scrollTop = chatHistory.scrollHeight;
      }, 1000);
    }, 400);
  }
</script>
</body>
</html>
'@

Set-Content -Path stream.html -Value ($baseHTML + $streamMain)
Set-Content -Path chat.html -Value ($baseHTML + $chatMain)
