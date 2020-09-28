local Component = import 'Component.jsonnet';

Component + {
  delivery_guarantee: error 'Must set `delivery_guarantee`'
}
