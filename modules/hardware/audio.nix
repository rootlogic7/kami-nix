{ pkgs, ... }:

{
  # PipeWire ist der moderne Standard für Audio unter Linux
  # Es ersetzt PulseAudio, ALSA und JACK und bietet bessere Latenz und BT-Codec Support.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    
    # Optional: JACK Unterstützung für Audio-Produktion (DAWs)
    jack.enable = true;
  };

  # Ein GUI-Tool zur Steuerung der Lautstärke und Ein-/Ausgänge
  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
}
