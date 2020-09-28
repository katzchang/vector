local DeliveryGuarantee = import '../Types/DeliveryGuarantee.jsonnet';
local EventType = import '../Types/EventType.jsonnet';
local FunctionCategory = import '../Types/FunctionCategory.jsonnet';
local MultiLine = import '../Types/MultiLine.jsonnet';
local Option = import '../Types/Option.jsonnet';
local Source = import '../Types/Source.jsonnet';
local Strategy = import '../Types/Strategy.jsonnet';
local Type = import '../Types/Type.jsonnet';
local Unit = import '../Types/Unit.jsonnet';

Source + {
  beta: false,
  common: true,
  delivery_guarantee: DeliveryGuarantee.BestEffort,
  features: [
    "Tail one or more files.",
    "Automatically discover new files with glob patterns.",
    MultiLine.Feature,
    "Checkpoint your position to ensure data is not lost between restarts.",
    "Enrich your logs with useful file and host-level context.",
  ],
  function_category: FunctionCategory.Collect,
  name: "file",
  noun: "a file",
  output_types: [EventType.Log],
  requirements: {
    file_system: true,
  },
  strategies: [Strategy.Daemon, Strategy.Sidecar],
  through_description: "one or more local files",
  title: "File",
  options+: [
    Option + {
      description: "The directory used to persist file checkpoint positions. By default, the [global `data_dir` option][docs.global-options#data_dir] is used. Please make sure the Vector project has write permissions to this dir.",
      examples: [
        "/var/lib/vector"
      ],
      name: "data_dir",
      required: false,
      templateable: false,
      type: Type.String,
    },
    Option + {
      description: "Array of file patterns to exclude. [Globbing](#globbing) is supported.*Takes precedence over the [`include` option](#include).*",
      examples: [
        [
          "/var/log/nginx/*.[0-9]*.log"
        ]
      ],
      name: "exclude",
      required: false,
      templateable: false,
      type: Type.ArrayOfStrings,
    },
    Option + {
      category: "Context",
      default: "file",
      description: "The key name added to each event with the full path of the file.",
      examples: [
        "file"
      ],
      name: "file_key",
      required: false,
      templateable: false,
      type: Type.String,
    },
    Option + {
      children: [
        Option + {
          default: "checksum",
          description: "The strategy used to uniquely identify files. This is important for [checkpointing](#checkpointing) when file rotation is used.",
          enum: {
            checksum: "Read `fingerprint_bytes` bytes from the head of the file to uniquely identify files via a checksum.",
            device_and_inode: "Uses the [device and inode][urls.inode] to unique identify files."
          },
          examples: [
            "checksum",
            "device_and_inode"
          ],
          name: "strategy",
          required: false,
          templateable: false,
          type: Type.String
        },
        Option + {
          default: 256,
          description: "The number of bytes read off the head of the file to generate a unique fingerprint.",
          name: "fingerprint_bytes",
          relevant_when: {
            strategy: "checksum"
          },
          required: false,
          templateable: false,
          type: Type.UInt,
          unit: "bytes"
        },
        Option + {
          default: 0,
          description: "The number of bytes to skip ahead (or ignore) when generating a unique fingerprint. This is helpful if all files share a common header.",
          name: "ignored_header_bytes",
          relevant_when: {
            strategy: "checksum"
          },
          required: false,
          templateable: false,
          type: Type.UInt,
          unit: "bytes"
        }
      ],
      description: "Configuration for how the file source should identify files.",
      name: "fingerprinting",
      required: false,
      templateable: false,
      type: Type.Object,
    },
    Option + {
      default: 1000,
      description: "Delay between file discovery calls. This controls the interval at which Vector searches for files.",
      name: "glob_minimum_cooldown",
      required: false,
      templateable: false,
      type: Type.UInt,
      unit: Unit.Milliseconds
    },
    Option + {
      default: "host",
      description: "The key name added to each event representing the current host. This can also be globally set via the [global `host_key` option][docs.reference.global-options#host_key].",
      name: "host_key",
      required: false,
      templateable: false,
      type: Type.String,
    },
    Option + {
      description: "Ignore files with a data modification date that does not exceed this age.",
      examples: [
        86400
      ],
      name: "ignore_older",
      required: false,
      templateable: false,
      type: Type.UInt,
      unit: Unit.Seconds
    },
    Option + {
      description: "Array of file patterns to include. [Globbing](#globbing) is supported.",
      examples: [
        [
          "/var/log/nginx/*.log"
        ]
      ],
      name: "include",
      required: true,
      templateable: false,
      type: Type.ArrayOfStrings,
    },
    Option + {
      default: 102400,
      description: "The maximum number of a bytes a line can contain before being discarded. This protects against malformed lines or tailing incorrect files.",
      name: "max_line_bytes",
      required: false,
      templateable: false,
      type: Type.UInt,
      unit: Unit.Bytes
    },
    Option + {
      default: 2048,
      description: "An approximate limit on the amount of data read from a single file at a given time.",
      name: "max_read_bytes",
      required: false,
      templateable: false,
      type: Type.UInt,
      unit: Unit.Bytes
    },
    Option + {
      default: false,
      description: "Instead of balancing read capacity fairly across all watched files, prioritize draining the oldest files before moving on to read data from younger files.",
      name: "oldest_first",
      required: false,
      templateable: false,
      type: Type.Bool,
    },
    Option + {
      description: "Timeout from reaching `eof` after which file will be removed from filesystem, unless new data is written in the meantime. If not specified, files will not be removed.",
      examples: [
        0,
        5,
        60
      ],
      name: "remove_after",
      required: false,
      templateable: false,
      type: Type.UInt,
      unit: Unit.Seconds
    },
    Option + {
      default: false,
      description: "For files with a stored checkpoint at startup, setting this option to `true` will tell Vector to read from the beginning of the file instead of the stored checkpoint. ",
      name: "start_at_beginning",
      required: false,
      templateable: false,
      type: Type.Bool,
    },
    Option + {
      description: "The component type. This is a required field that tells Vector which component to use. The value _must_ be `#{name}`.",
      enum: {
        file: "The name of this component"
      },
      examples: [
        "file"
      ],
      name: "type",
      required: true,
      templateable: false,
      type: Type.String,
    }
  ]
}
