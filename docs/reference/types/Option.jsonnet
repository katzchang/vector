local Type = import 'Type.jsonnet';

{
  children: (
    if self.type == Type.Object then
      error 'Must set `children`'
    else
      []
  ),
  default: null,
  description: error 'Must set `description`',
  examples: (
    if self.type == Type.Bool then
      [self.default, !self.default]
    else if self.type == Type.Object then
      []
    else if self.default == null then
      error 'Must set `examples`'
    else [
      self.default
    ]
  ),
  name: error 'Must set `name`',
  required: error 'Must set `required`',
  templateable: (
    if self.type == Type.String then
      error 'Must set `templateable`'
    else
      false
  ),
  type: error 'Must set `type`'
}
