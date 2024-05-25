# Define the custom hermit segment
function prompt_hermit() {
  if [[ -n $HERMIT_ENV ]]; then
    p10k segment -f yellow -t "🐚"
  fi
}

# Add this to the end of .p10k.zsh
# # Source custom hermit segment
# source ~/.p10k_custom_hermit.zsh

# Update the right prompt elements in .p10k.zsh
#  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
#    # =========================[ Line #1 ]=========================
#    ...
#    hermit                    # hermit status
#    # =========================[ Line #2 ]=========================
#    newline                   # \n
#  )
