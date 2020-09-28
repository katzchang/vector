local Option = import 'Option.jsonnet';
local Type = import 'Type.jsonnet';

local Options() = Option + {
  type: Type.Table,
  description: |||
    Multiline parsing configuration. If not specified, multiline parsing is
    disabled.
  |||,
  options: [
    Option + {
      name: "start_pattern",
    }
  ]
};

{
  Feature: "Merge multi-line logs into one event.",
  Options: Options,
}
