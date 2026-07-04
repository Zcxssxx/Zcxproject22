pub(all) struct Actor[Msg] {
  started: (Context[Msg]) -> Unit
  stopped: (Context[Msg]) -> Unit
  receive: (Msg, Context[Msg]) -> Unit
}

pub fn[Msg] Actor::new(
  started : (Context[Msg]) -> Unit,
  stopped : (Context[Msg]) -> Unit,
  receive : (Msg, Context[Msg]) -> Unit
) -> Actor[Msg] {
  { started: started, stopped: stopped, receive: receive }
}
