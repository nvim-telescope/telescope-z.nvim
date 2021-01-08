local z_builtin = require'telescope._extensions.z_builtin'

return require'telescope'.register_extension{
  exports = {
    list = z_builtin.list,
  },
}
