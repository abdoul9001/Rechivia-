/// Simule le délai d'un appel réseau dans les faux dépôts.
///
/// Quand [latency] vaut zéro, aucun minuteur n'est créé. Cela permet aux
/// tests de widgets d'avancer immédiatement sans attendre un timer.
Future<void> simulateLatency(Duration latency) {
  if (latency == Duration.zero) return Future<void>.value();
  return Future<void>.delayed(latency);
}
