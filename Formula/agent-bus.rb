# Copied from scottbaggett/agent-bus packaging/homebrew/agent-bus.rb at each release.
# Edit the source there, not here.
class AgentBus < Formula
  desc "File-backed handoff bus for coding agents sharing repos and worktrees"
  homepage "https://github.com/scottbaggett/agent-bus"
  url "https://github.com/scottbaggett/agent-bus/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "e2e34d5a07eb719f0393b55b922878e6eb109960e09cb443ecff14378fc89f81"

  depends_on "jq"

  def install
    libexec.install Dir["*"]
    (libexec/".installed-version").write "v#{version}\n"
    bin.install_symlink libexec/"bin/agent-bus"
  end

  def caveats
    <<~EOS
      Wire agent-bus into the agents on this machine (Claude Code, OpenCode, Codex):
        agent-bus hooks
      Then, in each repo, set the team's rules:
        agent-bus init
      Hooks point at #{opt_libexec}, so `brew upgrade` needs no re-run,
      except for OpenCode's plugin copy: run `agent-bus hooks --opencode` after upgrading.
    EOS
  end

  test do
    assert_match "agent-bus", shell_output("#{bin}/agent-bus version")
  end
end
