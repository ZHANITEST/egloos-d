# egloos-d
[Egloos](http://www.egloos.com) [API](http://apicenter.egloos.com) in D 💎

## Implemented
👀 Only Implemented reading API's
1. GET @ [Category](http://apicenter.egloos.com/manual_category.php)'s
1. GET @ [Post list](http://apicenter.egloos.com/manual_post.php)
1. GET @ [Post data](http://apicenter.egloos.com/manual_post.php)

## Example
```d
import egloosd.api;
EgloosAPI client = new EgloosAPI("help"); // http://help.egloos.com
assert(client.category().length > 0);
```

## Testing (Requirment)
* **Windows:** [Windows10 SDK](https://developer.microsoft.com/en-us/windows/downloads/windows-sdk) 
* **Compiler:** [LDC2](https://github.com/ldc-developers/ldc/releases) 1.30.0 (DMD v2.100.1, LLVM 14.0.3, x86_64-pc-windows-msvc)

### Real Testing
```sh
git clone https://github.com/ZHANITEST/egloos-d
cd egloos-d
dub test
```