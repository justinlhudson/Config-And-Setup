if type nvidia-persistenced > /dev/null 2>&1; then
  ## Enable persistence mode
  # nvidia-persistenced --user foo
  nvidia-persistenced --persistence-mode
  # Legacy option
  sudo nvidia-smi -pm 1 &> /dev/null
fi
