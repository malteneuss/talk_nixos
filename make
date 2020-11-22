# Autorecompile on file changes
watchexec -e md "pandoc -t revealjs -s -o slides.html slides.md -V revealjs-url=./reveal.js -V theme=sky"
