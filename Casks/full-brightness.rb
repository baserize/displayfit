cask "full-brightness" do
  version "2026.05.08.001"
  sha256 "099fc07d614a4be53c9f29251c090d4a7b773f44552b86bcf349258bf6539d7b"

  url "https://github.com/baserize/full-brightness/releases/download/#{version}/Full-Brightness-#{version}.dmg"
  name "Full Brightness"
  desc "Set supported displays to a chosen brightness level"
  homepage "https://github.com/baserize/full-brightness"

  depends_on macos: ">= :tahoe"

  app "Full Brightness.app"

  zap trash: [
    "~/Library/Group Containers/group.com.baserize.fullbrightness",
    "~/Library/Preferences/com.baserize.fullbrightness.plist",
  ]
end
