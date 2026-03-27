local actions = import '../actions.libsonnet';
local lib = import '../gmailctl.libsonnet';
local helpers = import '../helpers.libsonnet';
local filters = import 'filters.libsonnet';

{
  all: [
    actions.skip {
      name:: 'yaqs',
      filter: filters.yaqs,
      actions+: {
        labels: ['yaqs'],
      },
    },
    actions.skip {
      name:: 'gerrit',
      filter: filters.gerrit,
      actions+: {
        labels: ['gerrit'],
      },
    },
    helpers.rule('gthanks', filters.gthanks, actions.label('gthanks')),
    actions.skip {
      name:: 'issues',
      filter: filters.issues,
      actions+: {
        labels: ['issues'],
      },
    },
    actions.skip {
      name:: 'cls',
      filter: filters.cls,
      actions+: {
        labels: ['cls'],
      },
    },
    actions.skip {
      name:: 'tgif',
      filter: filters.tgif,
      actions+: {
        labels: ['tgif'],
      },
    },
    actions.skip {
      name:: 'totw',
      filter: filters.totw,
      actions+: {
        labels: ['totw'],
      },
    },
    actions.skip {
      name:: 'sig-auth',
      filter: filters.sigAuth,
      actions+: {
        labels: ['sig-auth'],
      },
    },
  ] + lib.chainFilters([
    actions.ignore {
      // if emails are spam, they should be ignored.
      name:: 'SPAM',
      filter: { or: [
        filters.presubmits,
      ] },
    },
    // else if emails are important which may or may not addressed to me, they
    // should be marked as important.
    actions.important {
      name:: 'NOW',
      filter: { or: [
        // emails addressed to me.
        { and: [filters.fromManagers, helpers.directToMe] },
        // emails not addressed to me but are important
        { and: [filters.annoucements, { not: filters.tgif }] },
        filters.omg,
      ] },
    },
    actions.star {
      name:: 'TODO',
      filter: { or: [
        filters.totw,
        filters.sigAuth,
        filters.grad,
        filters.tgif,
      ] },
    },
  ]),
  tests: [
    {
      name: 'manager directly to me',
      messages: [
        {
          from: 'wcourtney@google.com',
          to: ['zshihang@google.com'],
        },
      ],
      actions: {
        markImportant: true,
      },
    },
  ],
}
