class SingBoxPremium < Formula
  desc "Universal proxy platform (sing-box) with premium features"
  homepage "https://github.com/sb-community/sing-box-premium"
  version "{{version}}"

  if OS.mac? && Hardware::CPU.arm?
    url {{darwin_arm_url}}
    sha256 "{{darwin_arm_sha256}}"
  elsif OS.mac? && Hardware::CPU.intel?
    url {{darwin_amd64_url}}
    sha256 "{{darwin_amd64_sha256}}"
  elsif OS.linux? && Hardware::CPU.intel?
    url {{linux_amd64_url}}
    sha256 "{{linux_amd64_sha256}}"
  elsif OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url {{linux_armv8_url}}
    sha256 "{{linux_armv8_sha256}}"
  elsif OS.linux? && Hardware::CPU.arm?
    url {{linux_armv7_url}}
    sha256 "{{linux_armv7_sha256}}"
  end

  def install
    bin.install "sing-box-premium" => "sing-box"
  end

  service do
    run [opt_bin/"sing-box", "run", "--config", etc/"sing-box/config.json"]
    run_type :immediate
    keep_alive true
    require_root true
    working_dir var
    log_path var/"log/sing-box.log"
    error_log_path var/"log/sing-box.log"
  end

  test do
    assert_match "sing-box", shell_output("#{bin}/sing-box --help")
  end
end
    log_path var/"log/sing-box.log"
    error_log_path var/"log/sing-box.log"
  end

  test do
    assert_match "sing-box"， shell_output("#{bin}/sing-box --help")
  end
end
