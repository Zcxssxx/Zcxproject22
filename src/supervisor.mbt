pub enum SupervisorStrategy {
  Resume
  Restart
  Stop
  Escalate
}

pub(all) struct Supervisor {
  strategy: SupervisorStrategy
}

pub fn Supervisor::new(strategy : SupervisorStrategy) -> Supervisor {
  { strategy: strategy }
}
