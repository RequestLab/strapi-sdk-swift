<p align="center"><img src="https://cldup.com/7umchwdUBh.png" /></p>

<h3 align="center">The official Strapi SDK for Swift.</h3>

---

<br>

## Install

```sh
pod 'Strapi'
```

## Start now

### New instance
```swift
import Strapi

let strapi = Strapi(baseURL: "http://localhost:1337")
```

### Authentications

#### Local
```swift
strapi.login(identifier: "username_or_email", password: "s3cr3t", success: { jwt, user in

}, failure: { error in

})
```

### CRUD
```swift
strapi.all(entries: "articles", success: { objects in

}, failure: { error in
    
})
```

### Files management
```swift
guard let image = UIImage(named: "image_name"), let data = UIImagePNGRepresentation(image) else {
    return
}

strapi.upload(files: [image], progress: { progress in

}, success: { objects in

}, failure: { error in

})
```

## API

### `Strapi(baseURL: String)`
### `register(username: String, email: String, password: String)`
### `login(identifier: String, password: String)`
### `logout()`
### `create(entry model: String, parameters: [String, Any])`
### `all(entries model: String)`
### `get(entry model: String, id: String)`
### `update(entry model: String, id: String, parameters: [String: Any])`
### `delete(entry model: String, id: String)`
### `files()`
### `file(id: String)`
### `upload(files: [Data])`

## Resources

* [Documentation](https://strapi.github.io/strapi-sdk-swift)

## Credits

* [requestlab](https://github.com/requestlab)

## License

MIT