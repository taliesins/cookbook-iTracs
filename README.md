# itracs-cookbook

Cookbook to install iTracs.

## Supported Platforms

Windows

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['itracs']['TARGETDIR']</tt></td>
    <td>String</td>
    <td>The location to install iTracs to</td>
    <td><tt>C:\Program Files (x86)\iTRACS Corp\iTRACS Physical Layer Manager v9.0\</tt></td>
  </tr>
  <tr>
    <td><tt>['itracs']['PIDKEY']</tt></td>
    <td>String</td>
    <td>The serial for iTracs</td>
    <td><tt> </tt></td>
  </tr>
</table>

## Usage

### itracs::default

Include `itracs` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[itracs::default]"
  ]
}
```

## License and Authors

Author:: Taliesin Sisson (taliesins@yahoo.com)
