{
  perSystem = { pkgs, ... }: {
    packages.inputplumber-rg35xx-h = pkgs.runCommand "inputplumber-rg35xx-h-config" { } ''
      mkdir -p $out/share/inputplumber/devices
      mkdir -p $out/share/inputplumber/profiles

      cp ${pkgs.writeText "rg35xx-h-device.yaml" (builtins.toJSON {
        version = 1;
        kind = "CompositeDevice";
        name = "Anbernic RG35XX-H";

        matches = [ ];

        options.auto_manage = true;

        source_devices = [
          {
            group = "gamepad";
            evdev.name = "H700 Gamepad";
          }
        ];

        target_devices = [
          "gamepad"
          "mouse"
        ];
      })} $out/share/inputplumber/devices/50-rg35xx-h.yaml

      cp ${pkgs.writeText "rg35xx-h-right-stick-mouse.yaml" (builtins.toJSON {
        version = 1;
        kind = "DeviceProfile";
        name = "RG35XX-H Right Stick Mouse";
        description = "Use the right analog stick as a mouse and R3 as left click";

        target_devices = [
          "gamepad"
          "mouse"
        ];

        mapping = [
          {
            name = "Right Stick Mouse";
            source_event.gamepad.axis = {
              name = "RightStick";
              deadzone = 0.18;
            };
            target_events = [
              {
                mouse.motion.speed_pps = 650;
              }
            ];
          }
          {
            name = "Right Stick Click";
            source_event.gamepad.button = "RightStick";
            target_events = [
              {
                mouse.button = "Left";
              }
            ];
          }
        ];
      })} $out/share/inputplumber/profiles/rg35xx-h-right-stick-mouse.yaml
    '';
  };
}

