local actions = import 'actions.libsonnet';
local filters = import 'filters.libsonnet';
local lib = import 'gmailctl.libsonnet';

{
  rule(name, filter, actions):: {
    name:: name,
    filter: filter,
    actions: actions,
  },
}
