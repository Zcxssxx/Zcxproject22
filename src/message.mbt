pub trait Message {
  type Result
}

pub trait Handler[M : Message] {
  handle(self, msg: M, ctx: Context) -> M::Result
}

