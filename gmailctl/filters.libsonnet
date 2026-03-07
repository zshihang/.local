local helpers = import '../helpers.libsonnet';
local context = import 'context.libsonnet';

{
  fromManagers:: helpers.fromAnyOf([
    'wcourtney@google.com',
    'dstrain@google.com',
    'dabacon@google.com',
    'boixo@google.com',
    'neven@google.com',
  ]),

  balglobal: {
    from: 'balglobal.com',
  },

  cls: {
    cc: 'reviewlog@google.com',
  },

  ganpati: { from: 'ganpati-noreply@google.com' },

  tap: { from: 'noreply-tap-eng@google.com' },

  noice: {
    or: [
      { from: 'nobody@google.com' },
      { from: 'mdb.cloud-console-test+noreply@google.com' },
      { to: 'quantum-cloud-auto@google.com' },
    ],
  },

  gerrit: {
    or: [
      { cc: 'noreply+kokoro@google.com' },
      { from: 'noreply+kokoro@google.com' },
      { from: '(Gerrit)' },
      { subject: '(borq-config[main])' },
      { list: 'gerrit-qswim.quantum-review.git.corp.google.com' },
      { subject: 'pyle3[main]' },
    ],
  },

  annoucements: {
    or: [
      { list: 'google@google.com' },
      { list: 'eng-announce@google.com' },
      { list: 'googlers-wa@google.com' },
      { list: 'everyone-sea-slu' },
      { list: 'quantum-quacs@google.com' },
      { list: 'quacs@google.com' },
      { list: 'borq-team@google.com' },
      { list: 'research-sea-fun@google.com' },
      { list: 'quantum-swe@google.com' },
      { list: 'quantum-hardware@google.com' },
      { list: 'quantum-software@google.com' },
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
    ],
  },

  // presubmits: {
  //   from: 'mdb.cloud-kubernetes-guitar-presubmit-jobs@google.com',
  // },

  // skip inbox
  skipList: {
    or: [
      $.cls,
      $.issues,
      $.gthanks,
      $.yaqs,
      $.gerrit,
      $.tap,
      $.noice,
      $.dogfood,
    ],
  },

  k8s: {
    or: [
      { list: 'kubernetes-sig-auth@googlegroups.com' }
      { list: 'sig-storage@googlegroups.com' },
      { list: 'dev@kubernetes.io' },
    ],
  },

  dogfood: {
    list: 'dogfood-announce@google.com',
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
