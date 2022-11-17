// Auto-imported filters by 'gmailctl download'.
//
// WARNING: This functionality is experimental. Before making any
// changes, check that no diff is detected with the remote filters by
// using the 'diff' command.

// Uncomment if you want to use the standard library.
// local lib = import 'gmailctl.libsonnet';
local actions = import 'actions.libsonnet';
local context = import 'context.libsonnet';
local filters = import 'filters.libsonnet';
local helpers = import 'helpers.libsonnet';
local ops = import 'ops.libsonnet';

{
  version: 'v1alpha3',
  author: {
    name: context.name,
    email: context.email,
  },
  rules: [
    helpers.rule('yaqs', filters.yaqs, actions.label('yaqs')),
    helpers.rule('issues', filters.issues, actions.label('issues')),
    helpers.rule('cls', filters.cls, actions.label('cls') + actions.unimportant),
    helpers.rule('gerrit', filters.gerrit, actions.label('gerrit') + actions.unimportant),
    helpers.rule('gthanks', filters.gthanks, actions.label('gthanks')),
    helpers.rule('sig-auth', filters.sigAuth, actions.label('sig-auth')),
    helpers.rule('zzz', filters.zzz, actions.archive + actions.label('zzz')),
    helpers.rule('skip', filters.skip, actions.skip),
    helpers.rule('important', filters.important, actions.important),
  ],
}
