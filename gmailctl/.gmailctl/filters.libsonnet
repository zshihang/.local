local context = import 'context.libsonnet';
local lib = import 'gmailctl.libsonnet';

{
  skip:: {
    or: [
      {
        and: [
          {
            or: [
              $.yaqs,
              $.gerrit,
              $.cls,
              $.issues,
              $.gthanks,
              $.sigAuth,
            ],
          },
          $.toMe,
        ],
      },
      $.sigAuth,
    ],
  },

  important:: {
    or: [
      $.toReports,
      { and: [$.fromManagers, $.directToMe] },
      $.omg,
    ],
  },

  zzz:: {
    or: [
      { and: [$.notToMe, { not: $.annoucements }, { not: $.gkeIdentity }, { not: $.sigAuth }, { not: $.toReports }] },
      $.presubmits,
    ],
  },

  toMe:: { to: context.email },

  directToMe:: lib.directlyTo(context.email),

  notToMe:: { not: $.toMe },

  notDirectlyToMe:: { not: $.directToMe },

  fromAnyOf(addresses):: { or: [{ from: x } for x in addresses] },

  toAnyOf(addresses):: { or: [{ to: x } for x in addresses] },

  fromManagers:: $.fromAnyOf([
    'ksteuer@google.com',
    'dazari@google.com',
    'ankishah@google.com',
    'srimand@google.com',
    'azakonov@google.com',
    'tsavor@google.com',
    'cgoldberg@google.com',
  ]),

  toReports:: $.toAnyOf([
    'ksteuer-reports@google.com',
    'srimand-reports@google.com',
    'azakonov-all@google.com',
    'tsavor-all@google.com',
    'cgoldberg-all@google.com',
    'urs-team@google.com',
    'bcalder-team-extended@google.com',
  ]),

  balglobal: {
    from: 'balglobal.com',
  },

  cls: {
    cc: 'reviewlog@google.com',
  },


  ganpati: { from: 'ganpati-noreply@google.com' },

  gerrit: {
    or: [
      { cc: 'noreply+kokoro@google.com' },
      { from: 'noreply+kokoro@google.com' },
      { from: '(Gerrit)' },
      { list: 'gerrit-gke-security.louhi-config-internal-review.googlesource.com' },
      { list: 'gerrit-gke-identity-zatar.gke-internal-review.googlesource.com' },
    ],
  },

  gkeIdentity: {
    list: 'gke-kubernetes-authnz google com',
  },

  annoucements: {
    or: [
      { list: 'google@google.com' },
      { list: 'eng-announce@google.com' },
      { list: 'googlers-wa@google.com' },
    ],
  },

  gthanks: {
    or: [
      { from: 'noreply+gthanks@google.com' },
      { to: 'noreply+gthanks@google.com' },
      { subject: 'peer bonus' },
      { subject: 'kudos' },
      { subject: 'spot bonus' },
    ],
  },

  issues: {
    and: [
      { from: 'buganizer-system' },
      { subject: 'Issue' },
    ],
  },

  omg: {
    or: [
      { list: 'major-incidents.google.com' },
      { to: 'gke-security-incidents@google.com' },
    ],
  },

  presubmits: {
    from: 'mdb.cloud-kubernetes-guitar-presubmit-jobs@google.com',
  },

  sigAuth: {
    list: 'kubernetes-sig-auth@googlegroups.com',
  },

  yaqs: {
    from: 'yaqs-carrier-pigeon@google.com',
  },

}
