pub trait Actor {
  started(self, ctx: Context) -> Unit
  stopped(self, ctx: Context) -> Unit
}

