# Copied from scottbaggett/agent-bus packaging/homebrew/agent-bus.rb at each release.
# Edit the source there, not here.
class AgentBus < Formula
  desc "File-backed handoff bus for coding agents sharing repos and worktrees"
  homepage "https://github.com/scottbaggett/agent-bus"
  url "https://github.com/scottbaggett/agent-bus/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "4d57d34470042dd7e2e3e7a98b925751dfc2bdc790c39dbb3864c331291cf2ba"

  depends_on "go" => :build
  depends_on "jq"

  def install
    cd "tui" do
      system "go", "build", "-trimpath", "-ldflags", "-s -w -X main.version=#{version}",
             "-o", buildpath/"bin/agent-bus-tui", "."
    end
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
    assert_match version.to_s, shell_output("#{libexec}/bin/agent-bus-tui --version")
  end
end
