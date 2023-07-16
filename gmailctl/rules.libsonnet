local actions = import '../actions.libsonnet';
local lib = import '../gmailctl.libsonnet';
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
    actions.skip {
      name:: 'gthanks',
      filter: filters.gthanks,
      actions+: {
        labels: ['gthanks'],
      },
    },
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
        { and: [filters.fromManagers, filters.directToMe] },
        // emails not addressed to me but are important
        filters.toReports,
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
    // else if emails are addressed to me, i might want to take a look at them.
    // actions.skip {
    //   name:: 'LATER',
    //   filters: filters.toMe,
    //   labels: ['LATER'],
    // },
    // else if emails not addressed to me, they should be ignored.
    actions.ignore {
      name:: 'IGNORE',
      filter: filters.notToMe,
    },
  ]),
  tests: [
    {
      name: 'manager directly to me',
      messages: [
        {
          from: 'ksteuer@google.com',
          to: ['zshihang@google.com'],
        },
      ],
      actions: {
        markImportant: true,
      },
    },
    {
      name: 'manager to reports',
      messages: [
        {
          to: ['ksteuer-reports@google.com'],
        },
      ],
      actions: {
        markImportant: true,
      },
    },
    {
      name: 'announcements',
      messages: [
        {
          lists: ['google@google.com'],
          subject: 'A difficult decision to set us up for the future',
        },
      ],
      actions: {
        markImportant: true,
      },
    },
    {
      name: 'tgif',
      messages: [
        {
          lists: ['google@google.com'],
          subject: 'At TGIF: XXX',
        },
      ],
      actions: {
        labels: ['tgif'],
        archive: true,
        markImportant: false,
        star: true,
      },
    },
  ],
}
