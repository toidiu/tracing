# tracing-serde

An adapter for serializing `tracing` types using `serde`.

[Documentation](https://docs.rs/tracing-serde/0.1.0/tracing_serde/index.html)

## Overview

`tracing-serde` enables serializing `tracing` types using
`serde`. `tracing` is a framework for instrumenting Rust programs
to collect structured, event-based diagnostic information.

Traditional logging is based on human-readable text messages.
`tracing` gives us machine-readable structured diagnostic
information. This lets us interact with diagnostic data
programmatically. With `tracing-serde`, you can implement a
`Subscriber` to serialize your `tracing` types and make use of the
existing ecosystem of `serde` serializers to talk with distributed
tracing systems.

Serializing diagnostic information allows us to do more with our logged
values. For instance, when working with logging data in JSON gives us
pretty-print when we're debugging in development and you can emit JSON
and tracing data to monitor your services in production.

The `tracing` crate provides the APIs necessary for instrumenting
libraries and applications to emit trace data.

## Usage

First, add this to your `Cargo.toml`:

```toml
[dependencies]
tracing = "0.1"
tracing-serde = "0.1"
```

Next, add this to your crate:

```rust
#[macro_use]
extern crate tracing;
extern crate tracing_serde;

use tracing_serde::AsSerde;
```

Please read the [`tracing` documentation](https://docs.rs/tracing/0.1.0/tracing/index.html)
for more information on how to create trace data.

This crate provides the `as_serde` function, via the `AsSerde` trait,
which enables serializing the `Attributes`, `Event`, `Id`, `Metadata`,
and `Record` `tracing` values.

For the full example, please see the [examples](../examples) folder.

Implement a `Subscriber` to format the serialization of `tracing`
types how you'd like.

```rust
pub struct JsonSubscriber {
    next_id: AtomicUsize, // you need to assign span IDs, so you need a counter
}

impl Subscriber for JsonSubscriber {

    fn new_span(&self, attrs: &Attributes) -> Id {
        let id = self.next_id.fetch_add(1, Ordering::Relaxed);
        let id = Id::from_u64(id as u64);
        let json = json!({
        "new_span": {
            "attributes": attrs.as_serde(),
            "id": id.as_serde(),
        }});
        println!("{}", json);
        id
    }
    // ...
}
```

After you implement your `Subscriber`, you can use your `tracing`
subscriber (`JsonSubscriber` in the above example) to record serialized
trace data.

## License

This project is licensed under the [MIT license](LICENSE).

### Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in Tokio by you, shall be licensed as MIT, without any additional
terms or conditions.
