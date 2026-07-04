enum CounterMsg {
  Increment
  Decrement
  Get
}

struct CounterState {
  mut value: Int
}

test "actor basics" {
  let system = System::new("TestSystem")
  
  let state = { value: 0 }
  
  let actor = Actor::new(
    fn(_ctx) { () },
    fn(_ctx) { () },
    fn(msg, _ctx) {
      match msg {
        Increment => state.value += 1
        Decrement => state.value -= 1
        Get => ()
      }
    }
  )
  
  let addr = system.spawn(actor)
  
  // Test tell (asynchronous)
  addr.tell(Increment)
  addr.tell(Increment)
  addr.tell(Decrement)
  system.run_pending()
  
  // Test ask (synchronous)
  let count = addr.ask(Get, fn(_msg) { state.value })
  assert_eq(count, 1)
}
