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

  toReports:: helpers.toAnyOf([
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
