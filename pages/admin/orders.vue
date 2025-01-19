<template>
  <div>
    <h1 class="text-3xl font-bold text-gray-900 mb-8">Manage Orders</h1>

    <div class="bg-white shadow overflow-hidden sm:rounded-lg">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
          <tr>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Order ID</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Plate Number</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Customer</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          <tr v-for="order in orders" :key="order.id">
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
              {{ order.id }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
              {{ order?.plates?.number }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
              {{ order?.profiles?.email }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
              <select v-model="order.status" @change="updateOrderStatus(order)"
                class="border border-gray-300 rounded-md shadow-sm py-1 px-2 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                <option value="pending">Pending</option>
                <option value="completed">Completed</option>
                <option value="cancelled">Cancelled</option>
              </select>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
              {{ new Date(order.created_at).toLocaleDateString() }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
const client = useSupabaseClient()

const { data: orders } = await useAsyncData('admin-orders', async () => {
  const { data: users, error: e } = await client.rpc('admin_list_users');
  const { data } = await client
    .from('orders')
    .select(`
      *,
      plates(*)
    `)

  const result = data.map((order) => {
    return {
      ...order,
      profiles: users.find((user) => user.id === order.user_id)
    }
  })
  console.log(result)
  return result
})

const updateOrderStatus = async (order) => {
  console.log(order)
  try {
    switch (order.status) {
      case 'cancelled':
        await client.from('plates').update({ status: 'available' }).eq('id', order.plate_id)
        break;

      case 'completed':
        await client.from('plates').update({ status: 'sold' }).eq('id', order.plate_id)
        break;

      case 'pending':
        await client.from('plates').update({ status: 'pending' }).eq('id', order.plate_id)
    }

    await client
      .from('orders')
      .update({ status: order.status })
      .eq('id', order.id)
  } catch (error) {
    console.error('Error updating order status:', error)
  }
}
</script>
