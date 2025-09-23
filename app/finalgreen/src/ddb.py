import os, boto3
from typing import Optional, Dict, Any

# TABLE_NAME must be provided via ECS task environment
_table = boto3.resource("dynamodb").Table(os.environ["TABLE_NAME"])

def put_mapping(short_id: str, url: str, created_at: int, ttl: Optional[int] = None):
    item: Dict[str, Any] = {"id": short_id, "url": url, "created_at": created_at, "hits": 0}
    if ttl is not None:
        item["ttl"] = ttl
    _table.put_item(Item=item)

def get_mapping(short_id: str):
    resp = _table.get_item(Key={"id": short_id}, ConsistentRead=True)
    return resp.get("Item")

def increment_hits(short_id: str):
    _table.update_item(
        Key={"id": short_id},
        UpdateExpression="SET hits = if_not_exists(hits, :zero) + :incr",
        ExpressionAttributeValues={":incr": 1, ":zero": 0},
        ReturnValues="NONE",
    )
