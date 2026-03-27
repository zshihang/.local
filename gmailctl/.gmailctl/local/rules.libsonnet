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
      name:: 'k8s',
      filter: filters.k8s,
      actions+: {
        labels: ['k8s'],
      },
    },
    actions.skip {
      name:: 'dogfood',
      filter: filters.dogfood,
      actions+: {
        labels: ['dogfood'],
      },
    },
    actions.skip {
      name:: 'interest',
      filter: filters.interest,
      actions+: {
        labels: ['interest'],
      },
    },
  ] + lib.chainFilters([
    // actions.ignore {
    //   // if emails are spam, they should be ignored.
    //   name:: 'SPAM',
    //   filter: { or: [
    //     // filters.presubmits,
    //   ] },
    // },
    // else if emails are important which may or may not addressed to me, they
    // should be marked as important.
    actions.important {
      name:: 'NOW',
      filter: filters.now,
    },
    actions.star {
      name:: 'TODO',
      filter: filters.todo,
    },
    // else if emails are addressed to me, i might want to take a look at them.
    // actions.skip {
    //   name:: 'LATER',
    //   filters: filters.toMe,
    //   labels: ['LATER'],
    // },
    // else if labeled emails not addressed to me, they should be ignored.
    actions.ignore {
      name:: 'IGNORE',
      filter: filters.ignore,
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
    {
      name: 'quacs',
      messages: [
        {
          lists: ['quacs@google.com'],
          from: 'nobody@google.com',
        },
      ],
      actions: {
        archive: true,
        markRead: true,
        markImportant: false,
      },
    },
    {
      name: 'vi-users',
      messages: [
        {
          lists: ['vi-users@google.com'],
        },
      ],
      actions: {
        labels: ['interest'],
        archive: true,
        markImportant: false,
      },
    },
    {
      name: 'eng-announce',
      messages: [
        {
          lists: ['eng-announce@google.com'],
        },
      ],
      actions: {
        labels: ['interest'],
        archive: true,
        markImportant: false,
      },
    },
    {
      name: 'dogfood',
      messages: [
        { lists: ['dogfood-announce@google.com'] },
        { lists: ['dogfood-announce-us@google.com'] },
      ],
      actions: {
        labels: ['dogfood'],
        archive: true,
        markImportant: false,
      },
    },
  ],
}
