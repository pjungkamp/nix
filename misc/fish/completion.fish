function _nix_get_completions
  # Get the current command up to but excluding the token with the cursor.
  set -l nix_args (commandline --current-process --tokens-expanded --cut-at-cursor)
  # Append the token with the cursor.
  set -a nix_args (commandline --current-token --cut-at-cursor)
  # Erase the program name in nix_args[1].
  set -e nix_args[1]

  NIX_GET_COMPLETIONS=(count $nix_args) nix $nix_args
end

function _nix_accepts_files
  set -l response (_nix_get_completions)
  test "$response[1]" = 'filenames'
end

function _nix_non_file_completions
  # The first line is "normal" or "filenames" which indicates whether to enable filename completion.
  # The following lines each contain a command followed by a tab character and, optionally, a description.
  # This is also the format fish expects.
  set -l response (_nix_get_completions)
  set -e response[1]
  string collect -- $response
end

# Disable file path completion if paths do not belong in the current context.
complete --command nix --condition 'not _nix_accepts_files' --no-files
complete --command nix --arguments '(_nix_non_file_completions)'
