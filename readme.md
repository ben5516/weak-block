### WeakRef behavior vs Proc#weak!

_In RubyMotion, you can create a weak reference to an object ala_

```
@ref = WeakRef.new(object)
```

Calling a method on `@ref` after the underlying object has been dealloced raises:

```
@ref.test # => WeakRef::RefError
```

You can rescue from this error to do cleanup, etc.

By default, Procs in RM maintain a _strong_ reference to their owner, this easily results in
reference cycles and memory leaks:

```
class Thing

  def add_callback(cb)
    @callback = cb
  end

  def add_weak_callback(cb)
    @callback = cb.weak!
  end

end
@thing = Thing.new

block = proc { puts "hi" }

@thing.add_callback(block) # Strong reference cycle, will leak memory
@thing.add_weak_callback(block) # Weak owner, doesn't leak
```

_But *any* reference to this block after the owner has been dealloced results in a EXC_BAD_ACCESS/SEGFAULT crash_

Trying to find the cause of this can be very difficult, especially in larger codebases.

### Proposal

Accessing `.weak!` blocks after the owner has been dealloced should result in `WeakRef::RefError`
