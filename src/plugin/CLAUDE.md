# Plugin Module Rules

---

## main.py
- Role: Plugin entry point
- Prohibit: Business logic, Direct API calls
- Delegate collection to Manager

---

## config/
- Role: Global settings, Constants
- Filename: `{usage}_conf.py`
- Prohibit: Logic, Other module imports

---

## connector/
- Role: External API communication, Raw data collection
- Filename: `{service}/{resource}_connector.py`
- Classname: `{Resource}Connector`
- Prohibit: Data transformation, Manager calls
- Pattern:
  ```python
  class {Resource}Connector(BaseConnector):  # base.py inheritance required
      def list_{resources}(self, **kwargs):
          # Pagination required
          return self.client.list_resources(...)
  ```

---

## manager/
- Role: Data processing, CloudService/CloudServiceType creation
- Filename: `{service}/{resource}_manager.py`
- Classname: `{Resource}Manager`
- Prohibit: Direct API calls (use Connector)
- Pattern:
  ```python
  class {Resource}Manager(ResourceManager):  # base.py inheritance required
      def create_cloud_service_type(self):
          return make_cloud_service_type(
              name=self.cloud_service_type,
              group=self.cloud_service_group,
              provider=self.provider,
              metadata_path=f"metadata/{service}/{resource}.yaml",
              tags={"spaceone:icon": "..."},
              labels=[...]
          )

      def create_cloud_service(self, options, secret_data, schema):
          connector = {Resource}Connector(secret_data)
          for raw in connector.list_{resources}():
              try:
                  yield make_cloud_service(  # Generator required
                      name=raw.get("name"),
                      cloud_service_type=self.cloud_service_type,
                      cloud_service_group=self.cloud_service_group,
                      provider=self.provider,
                      data=raw,
                      account=account_id,
                      region_code=region,
                      reference={"resource_id": resource_id}
                  )
              except Exception as e:  # Individual error handling
                  yield make_error_response(
                      error=e,
                      provider=self.provider,
                      cloud_service_group=self.cloud_service_group,
                      cloud_service_type=self.cloud_service_type
                  )
  ```

---

## metadata/
- Role: CloudServiceType UI definition
- Filename: `{service}/{resource}.yaml`
- Prohibit: Python logic
- Pattern:
  ```yaml
  widget:
    - name: Total Count
      type: card
      query:
        filter:
          - key: provider
            value: {provider}
          - key: cloud_service_group
            value: {group}
          - key: cloud_service_type
            value: {type}
  table:
    sort:
      key: data.{field}
    fields:
      - {Display}: data.{field}
  tabs.0:
    name: Details
    type: item
    fields:
      - {Display}: data.{field}
  ```

---

## metrics/
- Role: Metric/Namespace definition
- Filename: `{service}/{resource}/namespace.yaml`, `{service}/{resource}/{metric}.yaml`
- Prohibit: Python logic
- Pattern:
  ```yaml
  # namespace.yaml
  namespace_id: ns-{provider}-{service}-{resource}
  name: {Service}/{Resource}
  category: ASSET
  resource_type: inventory.CloudService:{provider}.{Service}.{Resource}

  # {metric}.yaml
  metric_id: metric-{provider}-{service}-{resource}-{name}
  metric_type: GAUGE
  namespace_id: ns-{provider}-{service}-{resource}
  query_options:
    group_by:
      - key: account
        name: Account ID
    fields:
      value:
        operator: count
  unit: Count
  ```
