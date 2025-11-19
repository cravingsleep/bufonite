return require('telescope').register_extension({
  setup = function() end,
  exports = {
    bufonite = require('bufonite.telescope').picker,
  },
})
