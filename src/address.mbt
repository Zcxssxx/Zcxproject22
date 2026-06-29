pub struct Address[A] {
  // channel to actor
}


pub fn ask[A, M : Message](self: Address[A], msg: M) -> M::Result {
  // wait for response
  abort(
ot implemented)
}


pub fn tell[A, M : Message](self: Address[A], msg: M) -> Unit {
  // fire and forget
}

