{
  read: {
    markRead: true,
  },

  skip: {
    archive: true,
  },

  archive: {
    archive: true,
    markImportant: false,
    markRead: true,
  },

  star: {
    star: true,
  },

  important: {
    markImportant: true,
  },

  unimportant: {
    markImportant: false,
  },


  label(l): {
    labels+: [l],
  },
}
