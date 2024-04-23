local ls = require('luasnip')

return {
  ls.s(
    {
      trig = "foo",
      name = "test",
      desc = "this is only a test",
    }, {
      ls.t({ "hello world!" })
    }
  ),
}
