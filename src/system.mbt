pub(all) struct System {
  name: String
  mut active_contexts: Array[() -> Bool]
}

pub fn System::new(name: String) -> System {
  { name: name, active_contexts: [] }
}

pub fn[Msg] System::spawn(self : System, actor : Actor[Msg]) -> Address[Msg] {
  let ctx = Context::new(actor, self)
  (actor.started)(ctx)
  self.active_contexts.push(fn() { ctx.run() })
  Address::new(ctx)
}

pub fn System::run_pending(self : System) -> Unit {
  let mut has_work = true
  while has_work {
    has_work = false
    for run_ctx in self.active_contexts {
      if run_ctx() {
        has_work = true
      }
    }
  }
}
