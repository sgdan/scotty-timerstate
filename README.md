# scotty-timerstate

Extends the [scotty](https://github.com/scotty-web/scotty) global state
example slightly to add a background timer thread that modifies the state
at regular intervals.

Use `make shell` to create and start a docker container based on [Nix](https://nixos.org/nix/)
with the build environment - around 3.8 Gigs! Once you have the `[nix-shell:/working]#`
prompt you can build and run using nix commands or cabal (easier for dev).

```bash
nix-build release.nix
result/bin/scotty-timerstate
```

```bash
cabal run scotty-timerstate
```

Once running on http://localhost:3000 you can trigger manual state changes
by going to http://localhost:3000/plusone and http://localhost:3000/plustwo.
After a while you should see an increased tickCount value and various channel
values in the JSON returned by the server e.g.

```json
{"channels":["timer","timer","timer","plustwo","timer","plusone","timer","timer","initial"],"tickCount":21}
```

After updating dependencies in `working.cabal` use `cabal2nix . > default.nix`
to update the nix configuration.

## Useful links

- [Threading explanation](https://stackoverflow.com/questions/51908524/blocking-threads-in-haskell)
- [Haskell nix intro](https://maybevoid.com/posts/2019-01-27-getting-started-haskell-nix.html)
- [Nix and Haskell in production](https://github.com/Gabriel439/haskell-nix)
