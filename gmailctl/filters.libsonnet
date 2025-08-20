local context = import 'context.libsonnet';

{
  fromManagers:: $.fromAnyOf([
    'ksteuer@google.com',
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
    or: [
      { list: 'gke-kubernetes-authnz google com' },
      { cc: 'gke-kubernetes-authnz google com' },
    ],
  },

  annoucements: {
    or: [
      { list: 'google@google.com' },
      { list: 'eng-announce@google.com' },
      { list: 'googlers-wa@google.com' },
      { list: 'googlecloudorg@google.com' },
      { list: 'everyone-sea-slu' },
      { list: 'cr-pnw@google.com' },
      { list: 'cloud-runtimes-org' },
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

  grad: {
    from: 'notifications-google@betterworks.com',
  },

  yaqs: {
    from: 'yaqs-carrier-pigeon@google.com',
  },

  totw: {
    or: [
      { list: 'cpp-tips@google.com' },
    ],
  },

  tgif: {
    subject: 'TGIF',
  },
}
