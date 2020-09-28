local Option = import 'Option.jsonnet';
local Type = import 'Type.jsonnet';

{
  local component_name = self.name,

  beta: error 'Must set `beta`',
  common: error 'Must set `common`',
  features: error 'Must set `features`',
  function_category: error 'Must set `function_category`',
  name: error 'Must set `name`',
  noun: error 'Must set `noun`',
  options: [
    Option + {
      description: "The component type. This is a required field that tells Vector which component to use. The value _must_ be `#{name}`.",
      enum: {
        [component_name]: "The name of this component"
      },
      examples: [
        component_name
      ],
      name: "type",
      required: true,
      templateable: false,
      type: Type.String,
    }
  ],
  output_types: error 'Must set `output_types`',
  title: error 'Must set `title`',
}
