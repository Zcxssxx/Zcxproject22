pub(all) struct Context[Msg] {
  mut mailbox: Array[Msg]
  mut mailbox_index: Int
  actor: Actor[Msg]
  mut system: System
}

pub fn[Msg] Context::new(actor : Actor[Msg], system : System) -> Context[Msg] {
  { mailbox: [], mailbox_index: 0, actor: actor, system: system }
}

pub fn[Msg] Context::send(self : Context[Msg], msg : Msg) -> Unit {
  self.mailbox.push(msg)
}

pub fn[Msg] Context::run(self : Context[Msg]) -> Bool {
  if self.mailbox_index < self.mailbox.length() {
    let msg = self.mailbox[self.mailbox_index]
    self.mailbox_index += 1
    (self.actor.receive)(msg, self)
    true
  } else {
    false
  }
}
