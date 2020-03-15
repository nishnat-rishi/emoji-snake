# Emoji Snake
Designed in a few hours during exam season to relieve stress!

## Salient features
- Game state is not updated every frame. Only happens when a change is registered (emoji consumed, movement expected).
- User input is buffered every frame. Only the latest input is used. As such, responsiveness is maintained while retaining minimum resource usage.
- Game intentionally 'chokes' on the change-frame on which food is eaten. This provides feedback to the user regarding emoji consumption!
