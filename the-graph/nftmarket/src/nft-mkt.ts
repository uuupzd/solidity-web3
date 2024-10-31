import { Bytes } from "@graphprotocol/graph-ts";

import {
  Cancel as CancelEvent,
  List as ListEvent,
  Sold as SoldEvent
} from "../generated/NFTMkt/NFTMkt"
import {
  OrderBook,
  FilledOrder
} from "../generated/schema"

export function handleCancel(event: CancelEvent): void {
  let orderBookInfo = OrderBook.load(event.params.orderId)
  orderBookInfo!.status = "canceled"
  orderBookInfo!.cancelTxHash = event.transaction.hash

  orderBookInfo!.save()

}

export function handleList(event: ListEvent): void {
  let entity = new OrderBook(event.params.orderId) //orderId为主键
  entity.nft = event.params.nft
  entity.tokenId = event.params.tokenId
  entity.seller = event.params.seller
  entity.payToken = event.params.payToken
  entity.price = event.params.price
  entity.deadline = event.params.deadline
  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash
  entity.status = "pending"
  entity.cancelTxHash = Bytes.empty()
  entity.filledTxHash = Bytes.empty();

  entity.save()
}

export function handleSold(event: SoldEvent): void {
  let entity = new FilledOrder(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.sellOrderId = event.params.orderId
  entity.buyer = event.params.buyer
  entity.fee = event.params.fee
  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash
  let orderBookInfo = OrderBook.load(event.params.orderId)
  orderBookInfo!.status = "sold"
  orderBookInfo!.filledTxHash = event.transaction.hash
  orderBookInfo!.save()
  entity.order = orderBookInfo!.id

  entity.save()
}