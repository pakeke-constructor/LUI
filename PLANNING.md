

# PLANNING:

Ok, we want our own UI library.


# Obvious features we want:
- Use kirigami
- Heirarchal, decomposable
- Child elems can communicate with parent easily
    - `:getParent()`
    - `:getRoot()` <-- traverses all the way up tree
- Parent element knows about children
    - pass parent into child ctor?
    - `:getChildren()` method
- onHover / onHoverExit is easy to work with
- `:isHovered()` method
- Automatic stenciling (unless disabled)


# Interesting features to consider:
- "Box" or "div" elements
    - ie. an element type that exists to contain other elements
    - IDEA: this would be easy to create; just 


# Stuff to think about:
- Inputs:
    - How do we do mouse stuff?
    - How do we do text input and keyboard stuff?

what happens for temporary elements?
Ie. elements that come and go?
```lua
for k,v in ipai
```


# WARNING: 
 With this root stuff:
Make sure we handle overlapping clicks on elements!!!


