pub(all) struct Envelope[Msg] {
  message: Msg
}

pub fn[Msg] Envelope::new(message : Msg) -> Envelope[Msg] {
  { message: message }
}
