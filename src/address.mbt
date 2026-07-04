pub(all) struct Address[Msg] {
  context: Context[Msg]
}

pub fn[Msg] Address::new(context : Context[Msg]) -> Address[Msg] {
  { context: context }
}

pub fn[Msg] Address::tell(self: Address[Msg], msg: Msg) -> Unit {
  self.context.send(msg)
}

pub fn[Msg, Res] Address::ask(self: Address[Msg], msg: Msg, handler: (Msg) -> Res) -> Res {
  let _ = self
  handler(msg)
}
