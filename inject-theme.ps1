# Academic Elegance Theme Injector
# This script injects the CSS and JS into the HTML file

$htmlFile = 'd:\Antigravity\SIM CM 1\Github\SIM-CM-1-rmd.html'
$cssFile = 'd:\Antigravity\SIM CM 1\Github\academic-elegance-theme.css'

# Read the CSS content
$cssContent = Get-Content -Path $cssFile -Raw

# Build the style block to insert before </head>
$styleBlock = @"
<style class="academic-elegance-theme">
$cssContent
</style>
"@

# Build the JS block to insert before </body>
$jsBlock = @"
<!-- Academic Elegance: Progress Bar & Scroll Top -->
<div id="reading-progress-bar"></div>
<button id="scroll-to-top" title="Scroll to top">&#8593;</button>
<script>
(function() {
  // Reading progress bar
  var progressBar = document.getElementById('reading-progress-bar');
  window.addEventListener('scroll', function() {
    var scrollTop = window.scrollY || document.documentElement.scrollTop;
    var docHeight = document.documentElement.scrollHeight - document.documentElement.clientHeight;
    var scrollPercent = (scrollTop / docHeight) * 100;
    progressBar.style.width = scrollPercent + '%';
    
    // Scroll to top button visibility
    var btn = document.getElementById('scroll-to-top');
    if (scrollTop > 400) {
      btn.classList.add('visible');
    } else {
      btn.classList.remove('visible');
    }
  });
  
  // Scroll to top click
  document.getElementById('scroll-to-top').addEventListener('click', function() {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });
})();
</script>
"@

# Read the HTML file
Write-Host "Reading HTML file..."
$content = Get-Content -Path $htmlFile -Raw

# Check if theme is already injected
if ($content -match 'academic-elegance-theme') {
    Write-Host "WARNING: Theme appears to already be injected. Proceeding with fresh injection by removing old one first..."
    # Remove old style block
    $content = $content -replace '(?s)<style class="academic-elegance-theme">.*?</style>\r?\n?', ''
    # Remove old JS block  
    $content = $content -replace '(?s)<!-- Academic Elegance: Progress Bar & Scroll Top -->.*?</script>\r?\n?', ''
}

# Edit 1: Insert CSS before </head>
Write-Host "Injecting CSS before </head>..."
$content = $content -replace '(</head>)', "$styleBlock`r`n`$1"

# Edit 2: Insert HTML/JS before </body>
Write-Host "Injecting JS before </body>..."
$content = $content -replace '(</body>)', "$jsBlock`r`n`$1"

# Write back
Write-Host "Writing modified HTML file..."
[System.IO.File]::WriteAllText($htmlFile, $content)

Write-Host "Done! Academic Elegance theme has been applied."

# Verify
$newContent = Get-Content -Path $htmlFile -Raw
if ($newContent -match 'academic-elegance-theme' -and $newContent -match 'reading-progress-bar' -and $newContent -match 'scroll-to-top') {
    Write-Host "VERIFICATION PASSED: All theme components found in the file."
} else {
    Write-Host "VERIFICATION FAILED: Some theme components are missing!"
}
